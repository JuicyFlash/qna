import consumer from "./consumer"

$(document).on('turbolinks:load', function() {

        consumer.subscriptions.create({channel: "AnswersChannel", room_id: $('.question-details').attr('data-question-id')}, {
            connected() {
                this.perform('follow')
            },
            received(data) {
                if (gon.current_user_id !== data['user_id']) {
                    this.appendLine(data)
                }
            },
            appendLine(data) {
                const compiledTemplate = require("./templates/answer.hbs")(
                    {
                        id: data['id'],
                        body: data['body'],
                        files: data['files'],
                        links: data['links'],
                        like_link: data['like_link'],
                        dislike_link: data['dislike_link'],
                        is_author: is_author(data['author_id']),
                        can_vote: can_vote(data['author_id']),
                        can_best: can_best(data['author_id'], data['question_author_id']),
                        best_link: data['best_link']
                    })
                const element = document.querySelector(".answers")
                element.insertAdjacentHTML('beforeend', compiledTemplate)
            }
        })
});

function is_author(author_id){
    return gon.current_user_id == author_id
}
function can_vote(author_id){
    return !gon.current_user_id && !is_author(author_id) && user_signed_in()
}

function can_best(answer_author_id, question_author_id){
    return gon.current_user_id == question_author_id && gon.current_user_id !== answer_author_id
}

function user_signed_in(){
   return gon.current_user_id !== null
}

export function answer_html(data){
    return template({
        id: data['id'],
        body: data['body'],
        author: is_author(data['author_id']),
        votes_value: data['votes_value'],
        can_vote: can_vote(data['author_id'])
    })
}
