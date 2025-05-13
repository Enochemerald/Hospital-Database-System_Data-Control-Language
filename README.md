# 🏥 Hospital Database System – Data Control Language (DCL)

This outlines the implementation of **Data Control Language (DCL)** in a hospital database system, focusing on **user roles**, **privileges**, and a **secure access control strategy**. The system is designed to protect sensitive medical information while ensuring authorized access for various healthcare professionals.

---

## 👥 User Roles & Privileges

Each database user is assigned a role with privileges tailored to their job responsibilities. This follows the **principle of least privilege**, ensuring that users access only what they need.

| **Role**       | **Description**                                                  | **Privileges**                             | **User Account**         |
|----------------|------------------------------------------------------------------|--------------------------------------------|---------------------------|
| **Admin**      | Full control over the entire database                            | `SELECT`, `INSERT`, `UPDATE`, `DELETE`, etc. on **all** tables | `admin@localhost`         |
| **Physician**  | Manage patient data and prescriptions                            | `SELECT`, `INSERT`, `UPDATE` on `patient`, `prescribes` | `doctor@localhost`        |
| **Nurse**      | View and update patient details                                  | `SELECT`, `INSERT` on `patient`            | `nurse@localhost`         |
| **Pharmacist** | Dispense medications based on prescription data                 | `SELECT` on `prescribes`                   | `pharmacist@localhost`    |

---

## 🔐 Access Control Strategy

Security is a top priority in managing healthcare data. The access control model in this system is built on **Role-Based Access Control (RBAC)** and other key security principles:
Implementing a secure and efficient access control strategy was a key priority in designing the MediCare database. The strategy focuses on restricting user privileges to ensure that staff members can only access or modify the data relevant to their roles. By adhering to the principle of **least privilege**, we minimize the risk of unauthorized access to sensitive information while maintaining operational efficiency.

### ✅ Role-Based Access Control (RBAC)
The database employs a role-based access control (RBAC) approach, where each user is assigned a specific role within the system, determining their level of access. This simplifies management and ensures that permissions are aligned with job responsibilities.
- **Admin**: Full privileges across all tables.
- **Physician**: Access to patient and prescription data.
- **Nurse**: Limited access to patient data only.
- **Pharmacist**: Read-only access to prescriptions.

### ✅ Principle of Least Privilege
Each user role is assigned the **minimal privileges** necessary to perform their job functions. This approach reduces the risk of accidental or malicious data manipulation. For example, while physician can update patient and prescription data, they cannot modify other parts of the database, such as medication records.

### ✅ User Account Isolation
 Each role is associated with a unique user account, preventing cross-role access. Physician, nurses, pharmacists, and receptionists each log into separate accounts with distinct permissions, ensuring no overlap in capabilities. This also aids in tracking changes made to the database, as each action is associated with a specific user account.


### ✅ Granular Permission Control
Permissions are set at a granular level, restricting access to specific tables. For instance, only the **pharmacist** can view prescription details but cannot alter them, while **receptionists** can update patient details but are restricted from accessing medical information like prescriptions.

---

## 📌 Summary

This hospital database system ensures:
- **Security**, by controlling data access
- **Integrity**, by limiting modification privileges
- **Compliance**, with medical data regulations through RBAC

> 🛡️ A secure healthcare database is not just a technical goal—it's a moral responsibility.

---

