document.addEventListener('turbolinks:load',function() {
        $('.search-form').on('focus', '.search-query', function(e){
            e.preventDefault();
            $('.search-hint').removeClass('hidden')
        })
    }
);

document.addEventListener('turbolinks:load',function() {
        $('.search-form').on('focusout', '.search-query', function(e){
            e.preventDefault();
            $('.search-hint').addClass('hidden')
        })
    }
);
