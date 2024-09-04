import sql from '../db.js';
import { randomUUID } from 'node:crypto';

export const getBarber = async (req, res) => {
    try {
        const barbershops = await sql`select * from "barbershopbarber"`;
        console.log(barbershops);
        res.status(200).json(barbershops);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Erro ao buscar barbearias' });
    }
};


export const createBarber = async (request, response) => {
    const uuid = randomUUID();
    console.log(randomUUID);
    try {
        const { barberemail, barberwhatsapp, barbername, barberqtdservices, barbershopid} = request.body;

        const query = await sql`
            INSERT INTO barbershopbarber (barberid, barberemail, barberwhatsapp, barbername, barberqtdservices, barberimage, barbershopid) 
            VALUES (${uuid}, ${barberemail}, ${barberwhatsapp}, ${barbername}, ${barberqtdservices}, ${request.file ? request.file.filename : null}, ${barbershopid}) 
            RETURNING *;
        `;
        console.log( barberemail, barberwhatsapp, barbername, barberqtdservices, barbershopid);
        console.log("RESULTADO DO INSERT", query);
        response.status(200).json(query);
    } catch (error) {
        console.error(error);
        response.status(500).json({ message: 'Erro ao criar barbeiro' });
    }
};
