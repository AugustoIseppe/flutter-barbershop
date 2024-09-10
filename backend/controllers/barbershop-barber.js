import sql from '../db.js';
import { randomUUID } from 'node:crypto';

export const getBarber = async (req, res) => {
    const { barbershopid } = req.params;

    try {
        const barbershops = await sql`SELECT * FROM barbershopbarber WHERE barbershopid = ${barbershopid}`;
        console.log(barbershops);
        res.status(200).json(barbershops);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Erro ao buscar barbearias' });
    }
};

//Listar os barbeiros com o maior numero de serviços
export const bestRatedBarbers = async (response) => {
    try {
        const query = await sql`
            SELECT barbershopbarber.*, "Barbershop".*
            FROM "barbershopbarber"
            JOIN "Barbershop" ON barbershopbarber.barbershopid = "Barbershop".id
            ORDER BY barberqtdservices DESC;
        `;
        console.log('Query Executada:', query);
        response.status(200).json(query);
    } catch (error) {
        console.error('Erro na Query:', error);
        response.status(500).json({ message: 'Erro ao buscar barbeiros mais bem avaliados' });
    }
    
}
// SELECT "BarbershopService".*
// FROM "BarbershopService"
// WHERE "BarbershopService"."barbershopId" = ${id};
// `;

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

export const deleteBarber = async (request, response) => {
    const uuid = randomUUID();
    try {
        const { id } = request.params;
        const query = await sql`
            DELETE FROM barbershopbarber
            WHERE barberid = ${id}
            RETURNING *;
        `;
        console.log(query);
        res.status(200).json({ message: 'Barbeiro deletado com sucesso' });
    } catch (error) {
        console.error(error);
        response.status(500).json({ message: 'Erro ao deletar barbeiro' });
    }
}
