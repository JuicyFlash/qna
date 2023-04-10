document.addEventListener('turbolinks:load', function(){
    const comments_links = document.querySelectorAll('.comment-link')
    comments_links.forEach( (comment_link)=>
    {
        $(comment_link).on('click', showComments)

    })

    const submit_comments = document.querySelectorAll('.new-comment')
    submit_comments.forEach( (submit_comment)=>
    {
        $(submit_comment).on('ajax:success', addComment)

    })

})
function showComments(e){
    e.preventDefault();
    $(this).hide();
    const commentable_id = $(this).data('commentable-id');
    const commentable = $(this).data('commentable');
    $('#comments-'+commentable+'-'+commentable_id).removeClass('hidden')
    $('#close-comment-link-'+commentable+'-'+commentable_id).removeClass('hidden')
}
function addComment(e){
    const commentable_id = $(this).data('commentable-id');
    const commentable = $(this).data('commentable');
    const body = e.detail[0]['body']
    $('#comments-list-'+commentable+'-'+commentable_id).append(body)
}
