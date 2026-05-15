-- ========================================
-- Categories Table
-- ========================================
CREATE TABLE IF NOT EXISTS category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL
);

-- ========================================
-- Junction Table: Project <-> Category
-- (many-to-many relationship)
-- ========================================
CREATE TABLE IF NOT EXISTS project_category (
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
-- Insert sample categories
-- ========================================
INSERT INTO category (name) VALUES
('Environmental'),
('Community Support'),
('Education'),
('Health & Wellness'),
('Construction & Repair');

-- ========================================
-- Associate projects with categories
-- (project_id, category_id)
-- BrightFuture Builders projects: 1-5
-- GreenHarvest Growers projects: 6-10
-- UnityServe Volunteers projects: 11-15
-- ========================================
INSERT INTO project_category (project_id, category_id) VALUES
-- BrightFuture Builders
(1, 5),  -- Community Garden Build -> Construction & Repair
(1, 1),  -- Community Garden Build -> Environmental
(2, 5),  -- Park Renovation -> Construction & Repair
(2, 2),  -- Park Renovation -> Community Support
(3, 5),  -- Fence Repair Day -> Construction & Repair
(4, 1),  -- Trail Cleanup -> Environmental
(5, 3),  -- School Mural Project -> Education

-- GreenHarvest Growers
(6, 2),  -- Harvest Festival -> Community Support
(7, 3),  -- Composting Workshop -> Education
(7, 1),  -- Composting Workshop -> Environmental
(8, 1),  -- Urban Farm Planting Day -> Environmental
(9, 1),  -- Irrigation System Install -> Environmental
(10, 2), -- Seed Exchange Event -> Community Support
(10, 1), -- Seed Exchange Event -> Environmental

-- UnityServe Volunteers
(11, 2), -- Clothing Drive Sort -> Community Support
(12, 3), -- Senior Tech Help Day -> Education
(13, 4), -- Blood Drive Support -> Health & Wellness
(14, 4), -- Emergency Prep Fair -> Health & Wellness
(14, 3), -- Emergency Prep Fair -> Education
(15, 2); -- Animal Shelter Volunteer Day -> Community Support

SELECT * FROM category;
SELECT * FROM project_category;