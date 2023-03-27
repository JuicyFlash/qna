const Handlebars = require("handlebars");
const template = Handlebars.compile(
    "<div class='question' data-question-id={{id}}>" +
        "<div class='card'>" +
            "<div class='card-header'>{{title}}</div>" +
            "<div class='card-body'>" +
                "<p class='card-text'>{{body}}</p>" +
            "</div>"+
            "<div class='card-footer bg-transparent border-light'>" +
                "<div class='row justify-content-between'>" +
                    "<div class='col-4'> " +
                        "<a class='btn btn-primary' href='/questions/{{id}}'>Show </a>" +
                    "</div>" +
                    "<div class='col-4'>" +
                        "{{#if author}}" +
                            "<div class='d-grid gap-2 d-md-flex justify-content-md-end'>" +
                                "<a class='btn btn-outline-primary btn-sm' href='/questions/{{id}}/edit'>Edit </a>" +
                                "<a class='btn btn-outline-primary btn-sm' data-method='delete' href='/questions/{{id}}'>Delete </a>"+
                           "</div>" +
                        "{{/if}}"+
                    "</div>"+
               "</div>" +
            "</div>"+
        "</div>" +
        "<div class='container text-end'>" +
             "<div class='votes'>" +
                 "<div class='container text-end'> " +
                     "<div class='votes-value'>{{votes_value}}</div> " +
                     "{{#if can_vote}}}" +
                          "<div class= 'vote-links'> " +
                             "<a class='vote-link like' data-type='json' data-remote='true' rel='nofollow' data-method='patch' href='/questions/{{id}}/like'>Like</a>" +
                             "<a class='vote-link like' data-type='json' data-remote='true' rel='nofollow' data-method='patch' href='/questions/{{id}}/dislike'>Dislike</a>" +
                         "</div> " +
                     "{{/if}}"+
                 "</div>" +
             "</div>" +
        "</div>" +
    "</div>"
);

function is_author(author_id){
    return gon.current_user_id == author_id
}
function can_vote(author_id){
    return !gon.current_user_id && !is_author(author_id)
}
export function question_html(data){
    return template({
        id: data['id'],
        title: data['title'],
        body: data['body'],
        author: is_author(data['author_id']),
        votes_value: data['votes_value'],
        can_vote: can_vote(data['author_id'])
    });
}



