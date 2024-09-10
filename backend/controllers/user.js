import sql from '../db.js';
import { randomUUID } from 'node:crypto'; //? -> Importa a função randomUUID da biblioteca crypto do Node.js para gerar um id único para os vídeos

export const getUsers = async (request, response) => {
    try {
        const users = await sql`select * from "User"`;
        console.log(users);
        response.status(200).json(users); // Enviando a resposta de volta ao cliente
    } catch (error) {
        console.error(error);
        response.status(500).json({ message: 'Erro ao buscar usuários' }); // Tratamento de erro
    }
};

export const createUser = async (request, response) => {
    const uuid = randomUUID();
    console.log(randomUUID);
    try {
        const { email, name, password, phone } = request.body;

        const query = await sql`
            INSERT INTO "User" (id, email, name, password, phone, image) 
            VALUES (${uuid}, ${email}, ${name}, ${password}, ${phone}, ${request.file ? request.file.filename : null}) 
            RETURNING *;
        `;
        console.log(query);
        response.status(200).json(query);
    } catch (error) {
        //request entity too large -> erro de tamanho de arquivo
        console.error(error);
        response.status(500).json({ message: 'Erro ao criar usuário' });
    }
};


export const userLogin = async (req, res) => {
    try {
        const { email, password } = req.body;
        const query = await sql`
            SELECT * FROM "User" 
            WHERE email = ${email} AND password = ${password};
        `;

        if (query.length === 0) {
            return res.status(401).json("Usuário ou senha inválidos!");
        }
        return res.status(200).json(query);
    } catch (error) {
        console.error('Erro ao logar usuário:', error);
        return res.status(500).json({ message: 'Erro ao logar usuário' });
    }
};


// export const updateUser = async (req, res) => {
//     try {
//         const { id } = req.params;
//         const { email, name, password, phone} = req.body;

//         // Se `imageUrl` não for passado no corpo da requisição, preserve o valor existente
//         const query = await sql`
//             UPDATE "User" 
//             SET 
//                 email = ${email}, 
//                 name = ${name}, 
//                 password = ${password}, 
//                 phone = ${phone},
//             WHERE id = ${id} 
//             RETURNING *;
//         `;

//         console.log(query);
//         res.status(200).json(query);
//     } catch (error) {
//         console.error(error);
//         res.status(500).json({ message: 'Erro ao atualizar usuário' });
//     }
// }


export const updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        const { email, name, password, phone } = req.body;
        const query = await sql`
            UPDATE "User" 
            SET email = ${email}, name = ${name}, password = ${password}, phone = ${phone} 
            WHERE id = ${id} 
            RETURNING *;
        `;
        console.log(query);
        res.status(200).json(query);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Erro ao atualizar usuário' });
    }
}

// export const updateImageUser = async (req, res) => {
//     try {
//         const { id } = req.params;
//         const { image } = req.body;

//         // Se `imageUrl` não for passado no corpo da requisição, preserve o valor existente
//         const query = await sql`
//             UPDATE "User" 
//             SET 
//                 "image" = COALESCE(${image}, "image")
//             WHERE id = ${id} 
//             RETURNING *;
//         `;

//         console.log(query);
//         res.status(200).json(query);
//     } catch (error) {
//         console.error(error);
//         res.status(500).json({ message: 'Erro ao atualizar usuário' });
//     }
// }


export const updateImageUser = async (req, res) => {
    try {
        const { id } = req.params;
        const query = await sql`
            UPDATE "User" 
            SET image = ${req.file ? req.file.filename : null} 
            WHERE id = ${id} 
            RETURNING *;
        `;
        console.log(query);
        res.status(200).json(query);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Erro ao atualizar imagem do usuário' });
    }
}

export const deleteUser = async (req, res) => {
    try {
        const { id } = req.params;
        const query = await sql`
            DELETE FROM "User" 
            WHERE id = ${id} 
            RETURNING *;
        `;
        res.status(200).json({ message: 'Usuário deletado com sucesso' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Erro ao deletar usuário' });
    }
}