import consumer from "./consumer"

consumer.subscriptions.create('QuestionsChannel', {
    connected() {
        this.perform('follow')
    },
    received(data){
        this.appendLine(data)
    },
    appendLine(data) {
        const compiledTemplate = require("./templates/question.hbs")({
            id: data['id'],
            title: data['title'],
            body: data['body'],
            author: is_author(data['author_id']),
            votes_value: data['votes_value'],
            can_vote: can_vote(data['author_id'])
        });
        const element = document.querySelector(".questions")
        element.insertAdjacentHTML('beforeend', compiledTemplate);
    }
});

function is_author(author_id){
    return gon.current_user_id == author_id
}

function can_vote(author_id){
    return !gon.current_user_id && !is_author(author_id)
}