-- ========================================
-- Drop existing tables (in dependency order)
-- ========================================
DROP TABLE IF EXISTS project_category;
DROP TABLE IF EXISTS service_projects;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS organization;
DROP TABLE IF EXISTS volunteers;

-- ========================================
-- Organization Table
-- ========================================
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    contact_email VARCHAR(255),
    logo_filename VARCHAR(255)
);

-- ========================================
-- Insert sample organizations
-- ========================================
INSERT INTO organization (name, description, contact_email, logo_filename) VALUES
('BrightFuture Builders', 'A nonprofit focused on community construction and repair projects.', 'contact@brightfuture.org', 'placeholder-logo.png'),
('GreenHarvest Growers', 'Dedicated to urban farming, composting, and environmental education.', 'info@greenharvestgrowers.org', 'placeholder-logo.png'),
('UnityServe Volunteers', 'A volunteer network connecting people to local service opportunities.', 'hello@unityserve.org', 'placeholder-logo.png');

-- ========================================
-- Service Projects Table
-- ========================================
CREATE TABLE service_projects (
    project_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    date DATE,
    organization_id INT NOT NULL,
    CONSTRAINT fk_org
        FOREIGN KEY (organization_id)
        REFERENCES organization(organization_id)
        ON DELETE CASCADE
);

-- ========================================
-- Insert sample projects
-- ========================================
INSERT INTO service_projects (title, description, location, date, organization_id) VALUES
('Community Garden Build', 'Build raised garden beds at the local park.', 'Central Park', CURRENT_DATE + INTERVAL '10 days', 1),
('Park Renovation', 'Repaint benches and repair walkways.', 'Riverside Park', CURRENT_DATE + INTERVAL '20 days', 1),
('Fence Repair Day', 'Fix fencing around the community center.', 'Community Center', CURRENT_DATE + INTERVAL '30 days', 1),
('Trail Cleanup', 'Remove debris and restore trail markers.', 'Hillside Trail', CURRENT_DATE + INTERVAL '40 days', 1),
('School Mural Project', 'Paint a mural at the elementary school.', 'Lincoln Elementary', CURRENT_DATE + INTERVAL '50 days', 1),
('Harvest Festival', 'Celebrate the harvest with the community.', 'Town Square', CURRENT_DATE + INTERVAL '15 days', 2),
('Composting Workshop', 'Teach composting basics to residents.', 'Community Center', CURRENT_DATE + INTERVAL '25 days', 2),
('Urban Farm Planting Day', 'Plant vegetables at the urban farm.', 'Urban Farm', CURRENT_DATE + INTERVAL '35 days', 2),
('Irrigation System Install', 'Install drip irrigation at the community garden.', 'Community Garden', CURRENT_DATE + INTERVAL '45 days', 2),
('Seed Exchange Event', 'Exchange seeds with local gardeners.', 'Public Library', CURRENT_DATE + INTERVAL '55 days', 2),
('Clothing Drive Sort', 'Sort donated clothing for distribution.', 'Donation Center', CURRENT_DATE + INTERVAL '12 days', 3),
('Senior Tech Help Day', 'Help seniors with smartphones and tablets.', 'Senior Center', CURRENT_DATE + INTERVAL '22 days', 3),
('Blood Drive Support', 'Assist with logistics at the blood drive.', 'City Hall', CURRENT_DATE + INTERVAL '32 days', 3),
('Emergency Prep Fair', 'Educate the community on emergency preparedness.', 'Fairgrounds', CURRENT_DATE + INTERVAL '42 days', 3),
('Animal Shelter Volunteer Day', 'Help care for animals at the local shelter.', 'Animal Shelter', CURRENT_DATE + INTERVAL '52 days', 3);

-- ========================================
-- Category Table
-- ========================================
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL
);

-- ========================================
-- Insert sample categories
-- ========================================
INSERT INTO category (name) VALUES
('Environmental'),
('Community Support'),
('Education'),
('Health & Wellness'),
('Construction & Repair');

-- ========================================
-- Junction Table: Project <-> Category
-- ========================================
CREATE TABLE project_category (
    project_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (project_id, category_id),
    CONSTRAINT fk_project
        FOREIGN KEY (project_id)
        REFERENCES service_projects(project_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_category
        FOREIGN KEY (category_id)
        REFERENCES category(category_id)
        ON DELETE CASCADE
);

-- ========================================
-- Insert sample project/category associations
-- ========================================
INSERT INTO project_category (project_id, category_id) VALUES
(1, 5), (1, 1),
(2, 5), (2, 2),
(3, 5),
(4, 1),
(5, 3),
(6, 2),
(7, 3), (7, 1),
(8, 1),
(9, 1),
(10, 2), (10, 1),
(11, 2),
(12, 3),
(13, 4),
(14, 4), (14, 3),
(15, 2);

-- ========================================
-- Roles Table
-- ========================================
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT
);

-- ========================================
-- Insert initial roles
-- ========================================
INSERT INTO roles (role_name, role_description) VALUES
    ('user', 'Standard user with basic access'),
    ('admin', 'Administrator with full system access');

-- ========================================
-- Users Table
-- ========================================
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INTEGER REFERENCES roles(role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- Volunteers Table
-- ========================================
CREATE TABLE volunteers (
    volunteer_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    project_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_project
        FOREIGN KEY (project_id)
        REFERENCES service_projects(project_id)
        ON DELETE CASCADE,
    CONSTRAINT unique_volunteer UNIQUE (user_id, project_id)
);