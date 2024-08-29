import express from 'express';
import userRouter from './routes/users.js';
import barbershopRouter from './routes/barbershops.js';
import barberServiceRouter from './routes/barbershop-services.js';
import bookingsRouter from './routes/bookings.js';
import slotsRouter from './routes/default-slots.js';
import availableSlots from './routes/default-slots.js';
import cors from 'cors'; // Importação do CORS: Cross-Origin Resource Sharing -> Permite que um site acesse recursos de outro site mesmo estando em domínios diferentes
import multer from 'multer'; // Importação do multer: Middleware para upload de arquivos
import { storage } from './multerConfig.js'; // Importação da configuração do multer

const upload = multer({ storage: storage }); // Configuração do multer para salvar as imagens no diretório uploads
const app = express();
const port = 8800;

app.use(express.json());
app.use(cors()); // Habilita o CORS

app.use('/', userRouter);
app.use('/', barbershopRouter);
app.use('/', barberServiceRouter);
app.use('/', bookingsRouter);
app.use('/', slotsRouter);
app.use('/', availableSlots);
app.use('/users/uploads', express.static('uploads'));


app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});



