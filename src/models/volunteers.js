import db from './db.js';

const addVolunteer = async (userId, projectId) => {
    const query = `
        INSERT INTO volunteers (user_id, project_id)
        VALUES ($1, $2)
        ON CONFLICT (user_id, project_id) DO NOTHING
        RETURNING volunteer_id;
    `;
    const result = await db.query(query, [userId, projectId]);
    return result.rows[0] || null;
};

const removeVolunteer = async (userId, projectId) => {
    const query = `
        DELETE FROM volunteers
        WHERE user_id = $1 AND project_id = $2
        RETURNING volunteer_id;
    `;
    const result = await db.query(query, [userId, projectId]);
    return result.rows[0] || null;
};

const isVolunteer = async (userId, projectId) => {
    const query = `
        SELECT volunteer_id FROM volunteers
        WHERE user_id = $1 AND project_id = $2;
    `;
    const result = await db.query(query, [userId, projectId]);
    return result.rows.length > 0;
};

const getProjectsByVolunteer = async (userId) => {
    const query = `
        SELECT
            sp.project_id,
            sp.title,
            sp.date,
            sp.location,
            o.name AS organization_name
        FROM volunteers v
        JOIN service_projects sp ON v.project_id = sp.project_id
        JOIN organization o ON sp.organization_id = o.organization_id
        WHERE v.user_id = $1
        ORDER BY sp.date ASC;
    `;
    const result = await db.query(query, [userId]);
    return result.rows;
};

export { addVolunteer, removeVolunteer, isVolunteer, getProjectsByVolunteer };