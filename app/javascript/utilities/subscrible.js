document.addEventListener('turbolinks:load', function(){
    $('.subscrible-link').on('ajax:success', function(e){
        console.log(e.detail)
        const obj_class = e.detail[0]['subscrible']
        const obj_id = e.detail[0]['id']
        const have_subscription = e.detail[0]['have_subscription']
        const data_obj_id = '[data-'+obj_class+'-id='+obj_id+']'

        if (have_subscription == 'true') {
            $(''+data_obj_id+' .subscrible-link.subscribe').addClass('unsubscribe').removeClass('subscribe').attr("href", e.detail[0]['unsubscribe_path']).attr("data-method", "DELETE").text('Unsubscribe')
        }
        else
        {
            $(''+data_obj_id+' .subscrible-link.unsubscribe').addClass('subscribe').removeClass('unsubscribe').attr("href", e.detail[0]['subscribe_path']).attr("data-method", "post").text('Subscribe')
        }
    })
})