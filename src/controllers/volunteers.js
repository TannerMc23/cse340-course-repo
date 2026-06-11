import { addVolunteer, removeVolunteer } from '../models/volunteers.js';

const processAddVolunteer = async (req, res) => {
    const projectId = parseInt(req.params.projectId);
    const userId = req.session.user.user_id;

    try {
        await addVolunteer(userId, projectId);
        req.flash('success', 'You have signed up to volunteer for this project!');
    } catch (error) {
        console.error('Error adding volunteer:', error);
        req.flash('error', 'An error occurred. Please try again.');
    }

    res.redirect(`/project/${projectId}`);
};

const processRemoveVolunteer = async (req, res) => {
    const projectId = parseInt(req.params.projectId);
    const userId = req.session.user.user_id;

    try {
        await removeVolunteer(userId, projectId);
        req.flash('success', 'You have been removed as a volunteer for this project.');
    } catch (error) {
        console.error('Error removing volunteer:', error);
        req.flash('error', 'An error occurred. Please try again.');
    }

    const redirectTo = req.query.from === 'dashboard' ? '/dashboard' : `/project/${projectId}`;
    res.redirect(redirectTo);
};

export { processAddVolunteer, processRemoveVolunteer };