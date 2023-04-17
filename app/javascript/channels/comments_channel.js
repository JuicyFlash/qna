import consumer from "./consumer"

export function subscribe(commentable, commentable_id){
    consumer.subscriptions.create({channel: "CommentsChannel", commentable: commentable, room_id: commentable_id }, {
        connected() {
            this.perform('follow')
        },
        received(data) {
            if (gon.current_user_id !== data['user_id']) {
                this.appendLine(data)
            }
        },
        appendLine(data) {
            const commentable = data['commentable']
            const commentable_id = data['commentable_id']
            const element = document.querySelector('#comments-list-'+commentable+'-'+commentable_id)
            element.insertAdjacentHTML('beforeend', data['body'])
        }
    })
};

