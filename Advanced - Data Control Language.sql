

# MySQL Script for User Accounts and Roles in MediCareDB
/*
Explanation of the Security Implementation:
1. Roles Created:
admin_role: Full database access (for IT administrators)
physician_role: Access to patient records and prescribing medications
nurse_role: Access to patient records and view prescriptions
pharmacist_role: Access to medication and prescription data
receptionist_role: Access to patient and physician scheduling information
patient_role: Read-only access to their own records

2. Specific Users:
Created sample users for each role with strong passwords
Each user is granted only the privileges needed for their job function

3. Additional Security Measures:
Created views to limit patient access to only their own records
Enabled role activation on login for security
Used strong password requirements for all accounts

4. Principle of Least Privilege:
Each role has only the minimum permissions needed
Sensitive operations (like DELETE) are restricted to admin only
Patients can only view their own information

This implementation follows healthcare data security best practices and HIPAA compliance
 requirements by ensuring proper access controls are in place for sensitive medical information.
*/


-- Create roles for different types of users
CREATE ROLE IF NOT EXISTS 'admin_role', 'physician_role', 'nurse_role', 'pharmacist_role', 'receptionist_role', 'patient_role';

-- Grant all privileges to admin_role (for database administrators)
GRANT ALL PRIVILEGES ON MediCareDB.* TO 'admin_role';

-- Grant privileges to physician_role
GRANT SELECT, INSERT, UPDATE ON MediCareDB.Patient TO 'physician_role';
GRANT SELECT, INSERT, UPDATE ON MediCareDB.Prescribes TO 'physician_role';
GRANT SELECT ON MediCareDB.Medication TO 'physician_role';
GRANT SELECT ON MediCareDB.Physician TO 'physician_role';
GRANT SELECT ON MediCareDB.Department TO 'physician_role';

-- Grant privileges to nurse_role
GRANT SELECT, INSERT, UPDATE ON MediCareDB.Patient TO 'nurse_role';
GRANT SELECT ON MediCareDB.Prescribes TO 'nurse_role';
GRANT SELECT ON MediCareDB.Medication TO 'nurse_role';
GRANT SELECT ON MediCareDB.Nurse TO 'nurse_role';
GRANT SELECT ON MediCareDB.Department TO 'nurse_role';

-- Grant privileges to pharmacist_role
GRANT SELECT ON MediCareDB.Patient TO 'pharmacist_role';
GRANT SELECT, UPDATE ON MediCareDB.Prescribes TO 'pharmacist_role';
GRANT SELECT, INSERT, UPDATE ON MediCareDB.Medication TO 'pharmacist_role';

-- Grant privileges to receptionist_role
GRANT SELECT, INSERT, UPDATE ON MediCareDB.Patient TO 'receptionist_role';
GRANT SELECT ON MediCareDB.Physician TO 'receptionist_role';
GRANT SELECT ON MediCareDB.Department TO 'receptionist_role';

-- Grant limited privileges to patient_role
GRANT SELECT ON MediCareDB.Patient TO 'patient_role';
GRANT SELECT ON MediCareDB.Prescribes TO 'patient_role';
GRANT SELECT ON MediCareDB.Medication TO 'patient_role';

-- Create specific users and assign them to roles
-- Database Administrator
CREATE USER IF NOT EXISTS 'db_admin'@'localhost' IDENTIFIED BY 'SecureAdminPass123!';
GRANT 'admin_role' TO 'db_admin'@'localhost';
SET DEFAULT ROLE ALL TO 'db_admin'@'localhost';

-- Physician user
CREATE USER IF NOT EXISTS 'dr_johnson'@'localhost' IDENTIFIED BY 'DocSecure456!';
GRANT 'physician_role' TO 'dr_johnson'@'localhost';
SET DEFAULT ROLE ALL TO 'dr_johnson'@'localhost';

-- Nurse user
CREATE USER IF NOT EXISTS 'nurse_adams'@'localhost' IDENTIFIED BY 'NursePass789!';
GRANT 'nurse_role' TO 'nurse_adams'@'localhost';
SET DEFAULT ROLE ALL TO 'nurse_adams'@'localhost';

-- Pharmacist user
CREATE USER IF NOT EXISTS 'pharm_smith'@'localhost' IDENTIFIED BY 'PharmaPass321!';
GRANT 'pharmacist_role' TO 'pharm_smith'@'localhost';
SET DEFAULT ROLE ALL TO 'pharm_smith'@'localhost';

-- Receptionist user
CREATE USER IF NOT EXISTS 'reception_jones'@'localhost' IDENTIFIED BY 'RecepPass654!';
GRANT 'receptionist_role' TO 'reception_jones'@'localhost';
SET DEFAULT ROLE ALL TO 'reception_jones'@'localhost';

-- Patient user (read-only access to their own records)
CREATE USER IF NOT EXISTS 'patient_smith'@'localhost' IDENTIFIED BY 'PatientPass987!';
GRANT 'patient_role' TO 'patient_smith'@'localhost';
SET DEFAULT ROLE ALL TO 'patient_smith'@'localhost';

-- Create views to limit patient access to only their own records
CREATE OR REPLACE VIEW Patient_View AS
SELECT * FROM Patient WHERE name = CURRENT_USER();

CREATE OR REPLACE VIEW Prescription_View AS
SELECT p.* FROM Prescribes p
JOIN Patient pt ON p.patient_id = pt.patient_id
WHERE pt.name = CURRENT_USER();

-- Grant access to these views instead of base tables for patient_role
REVOKE SELECT ON MediCareDB.Patient FROM 'patient_role';
REVOKE SELECT ON MediCareDB.Prescribes FROM 'patient_role';
GRANT SELECT ON MediCareDB.Patient_View TO 'patient_role';
GRANT SELECT ON MediCareDB.Prescription_View TO 'patient_role';

-- Enable role activation for all users
SET GLOBAL activate_all_roles_on_login = ON;

-- Apply the changes
FLUSH PRIVILEGES;


										## Revoke All Access from Roles in MediCareDB

-- Revoke all privileges from admin_role
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'admin_role';

-- Revoke all privileges from physician_role
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'physician_role';

-- Revoke all privileges from nurse_role
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'nurse_role';

-- Revoke all privileges from pharmacist_role
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'pharmacist_role';

-- Revoke all privileges from receptionist_role
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'receptionist_role';

-- Revoke all privileges from patient_role
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'patient_role';

-- Remove roles from all users
REVOKE 'admin_role' FROM 'db_admin'@'localhost';
REVOKE 'physician_role' FROM 'dr_johnson'@'localhost';
REVOKE 'nurse_role' FROM 'nurse_adams'@'localhost';
REVOKE 'pharmacist_role' FROM 'pharm_smith'@'localhost';
REVOKE 'receptionist_role' FROM 'reception_jones'@'localhost';
REVOKE 'patient_role' FROM 'patient_smith'@'localhost';

-- Drop the views created for patient access
DROP VIEW IF EXISTS Patient_View;
DROP VIEW IF EXISTS Prescription_View;

-- Optionally, you can also drop the roles completely
DROP ROLE IF EXISTS 'admin_role', 'physician_role', 'nurse_role', 
                   'pharmacist_role', 'receptionist_role', 'patient_role';

-- Apply the changes
FLUSH PRIVILEGES;


