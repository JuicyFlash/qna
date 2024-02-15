document.addEventListener('turbolinks:load', function(){
    $('.subscrible-link').on('ajax:success', function(e){
        const obj_class = e.detail[0]['subscrible']
        const obj_id = e.detail[0]['id']
        const have_subscription = e.detail[0]['have_subscription']
        const data_obj_id = '[data-'+obj_class+'-id='+obj_id+']'

        if (have_subscription == 'true') {
            $(''+data_obj_id+' .subscrible-link.subscribe').addClass('hidden')
            $(''+data_obj_id+' .subscrible-link.unsubscribe').removeClass('hidden')
        }
        else
        {
           $(''+data_obj_id+' .subscrible-link.unsubscribe').addClass('hidden')
           $(''+data_obj_id+' .subscrible-link.subscribe').removeClass('hidden')
        }
    })
})