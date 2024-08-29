import multer from "multer";
import path from "path";
import fs from "fs";

// Configuração do multer para salvar as imagens no diretório 'uploads'
// Multer: Middleware para upload de arquivos

// Certifique-se de que o diretório 'uploads' existe
const uploadDir = path.resolve("uploads");
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir);
}

export const storage = multer.diskStorage({
    destination: (req, file, callback) => {
        callback(null, uploadDir);
    },
    filename: (req, file, callback) => {
        const time = new Date().getTime();
        callback(null, `${time}_${file.originalname}`);
    }
});

export const upload = multer({ storage });
