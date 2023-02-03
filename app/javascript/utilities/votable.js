document.addEventListener('turbolinks:load', function(){
    $('.vote-link').on('ajax:success', function(e){
        console.log(e)
        const obj_id = e.detail[0]['id']
        const obj_class = e.detail[0]['votable']
        const votes_val = e.detail[0]['value']
        const have_votes = e.detail[0]['have_votes']
        let like_name

        const data_obj_id = '[data-'+obj_class+'-id='+obj_id+']'
        $(''+data_obj_id+' .votes .votes-value').empty()
            .append(''+votes_val+'');

        if (have_votes == 'true') {
            like_name ='Unvote'
            $(''+data_obj_id+' .votes .vote-links .dislike').addClass('hidden')
        }
        else
        {
            like_name = 'Like'
            $(''+data_obj_id+' .votes .vote-links .dislike').removeClass('hidden')
        }
        $(''+data_obj_id+' .votes .vote-links .like').text(''+like_name+'')

    })
})
