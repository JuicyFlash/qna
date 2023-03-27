import consumer from "./consumer"
import {question_html} from "../questions/question"



consumer.subscriptions.create('QuestionsChannel', {
    connected() {
        this.perform('follow')
    },
    received(data){
        console.log('id = ' + !gon.current_user_id)
        this.appendLine(data)
    },
    appendLine(data) {
        const element = document.querySelector(".questions")
        element.insertAdjacentHTML('beforeend', question_html(data));
    }
})