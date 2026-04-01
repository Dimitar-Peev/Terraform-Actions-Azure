# TaskBoard Azure Infrastructure with Terraform

Това хранилище съдържа Terraform конфигурация за автоматизирано разгръщане на **TaskBoard** приложението в Azure, включително инфраструктура за съхранение на състоянието (Backend) и управление на достъпа (Service Principal).

## 🚀 Структура на проекта

Проектът е разделен на три логически модула, всеки със собствен Workflow в GitHub Actions:

1.  **`terraform-backend/`**: Инициализира Azure Storage Account и Container за отдалечено съхранение на `.tfstate` файловете.
2.  **`terraform-sp/`**: Извлича и потвърждава информация за използваната идентичност (Service Principal) и абонамент.
3.  **Root Directory (`main.tf`)**: Основната инфраструктура — App Service, SQL Server, Database и Networking.

---

## 🛠️ GitHub Actions Workflows

Всички работни процеси са напълно автоматизирани и използват **GitHub Secrets** за сигурност.

* **Provision Terraform Backend**: Създава ресурсите, необходими за Terraform Backend.
* **Provision Service Principal**: Потвърждава достъпа и извлича метаданни за текущия SP.
* **Terraform Plan Apply**: Основният пайплайн, който разгръща уеб приложението и базата данни.

---

## 🔐 Управление на тайни (Secrets)

За успешното изпълнение на Action-ите са конфигурирани следните секрети в GitHub:
* `AZURE_CLIENT_ID` / `AZURE_CLIENT_SECRET` / `AZURE_TENANT_ID`
* `AZURE_SUBSCRIPTION_ID`
* `SQL_ADMIN_LOGIN` / `SQL_ADMIN_PASSWORD`

---

## 📝 Бележки относно предизвикателствата (Challenges)

### 1. Автоматизация на Backend
Вместо ръчно създаване през CLI, беше създаден модулът `terraform-backend`. Използвана е процедура по **Terraform Import**, за да се поеме управлението над вече съществуващи ресурси в учебната среда на SoftUni.

### 2. Автоматизация на Service Principal
Конфигурацията за създаване на нов Service Principal е разработена и тествана. Поради специфични ограничения в правата на Azure Tenant-а (липса на **Admin Consent** за Microsoft Graph API в студентски акаунти), модулът е оставен във вариант, който извлича информация (`data sources`), вместо да създава нови обекти в Entra ID. 

> *Забележка: Пълният код за генериране на нов SP е наличен в историята на комитите и изисква роля "Application Administrator" за успешно изпълнение.*

---

## 🏗️ Как се използва?
1. Клонирайте хранилището.
2. Настройте GitHub Secrets.
3. Стартирайте Workflows в следната последователност: `Backend` -> `Service Principal` -> `Main Plan Apply`.

---