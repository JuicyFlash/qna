document.addEventListener('turbolinks:load', loadGist)

function loadGist(){
    $('[data-gist-url]').each(function() {
        let url = $(this).data( "gist-url")
        let id = $(this).attr('id')
        $.ajax({
            url: url + '.json',
            dataType: 'jsonp',
            timeout: 1000,
            success: function (data) {
                if($('[href="' + data.stylesheet + '"]').length === 0) {
                    $(document.head).append('<link href="' + data.stylesheet + '" rel="stylesheet">')
                }
                $('[id="'+id+'"]').append(data.div)
            },
            error: function (data) {
                console.log(data)
            },
        })
    });
}


