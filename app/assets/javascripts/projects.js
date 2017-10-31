$(document).on("turbolinks:load", function(){
    $('.new-task form').each(function () {
        var current_form = $(this);
        var input_task_field  = $('input.task-name', $(this));

        current_form.validate({
            onfocusout: false,
            submitHandler: function(form){
                $(form).trigger('submit.rails')
            }
        });

        input_task_field.focusout(function(){
            current_form.validate().resetForm();
        });

        current_form.on('ajax:complete', function(){
            input_task_field.val('');
        });
    });

    $('.tasks-list').each(function(){
        var current_list = $(this);
        var project_id = current_list.closest('div[data-project-id]').data('project-id');

        current_list.sortable({
            axis: 'y',
            update: function(event, ui){
                var new_order = $(this).sortable('toArray', { attribute: 'data-task-id' });

                $.ajax({
                    url: '/projects/' + project_id + '/tasks/reorder',
                    method: 'POST',
                    data: { order: new_order },
                    dataType: 'script'
                });
            }
        });
    });
});