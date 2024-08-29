import { randomUUID } from 'node:crypto'; //? -> Importa a função randomUUID da biblioteca crypto do Node.js para gerar um id único para os vídeos
export class DatabaseMemory {

    //set, map


    #videos = new Map()

    list() {
        return Array.from(this.#videos.entries()).map((videoArray) => {
            const id = videoArray[0]
            const video = videoArray[1]
            return { id, ...video }
        }) //? -> Retorna um array com todos os vídeos
    }

    create(video) {
        const videoId = randomUUID() //? -> Gera um id único para o vídeo
        this.#videos.set(videoId, video) //? -> Adiciona o vídeo ao Map de vídeos
    }

    update(id, video) {
        this.#videos.set(id, video) //? -> Atualiza o vídeo no Map de vídeos
    }

    delete(id) {
        this.#videos.delete(id) //? -> Deleta o vídeo do Map de vídeos
    }


}