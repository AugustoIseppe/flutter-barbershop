import express from 'express';
import { upload } from '../multerConfig.js';
import { getUsers, createUser, userLogin, updateUser, deleteUser, updateImageUser } from '../controllers/user.js';

const router = express.Router();

router.get('/users', getUsers);
router.post('/users', upload.single("image"), createUser);
router.post('/users/login', userLogin);
router.put('/users/:id', updateUser);
router.put('/users/updateImageUser/:id', upload.single("image"), updateImageUser);
router.delete('/users/:id', deleteUser);


export default router;