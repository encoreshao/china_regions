$(function() {
  $('body').on('change', '.region_select', function(event) {
    var changed_object = $(event.currentTarget);
    var target_dom = get_target(changed_object);

    if (target_dom.size() > 0) {
      get_options(changed_object, target_dom, deal_with_second_target);
    }
  });

  function get_target(dom_object) {
    return $('#' + dom_object.data('region-target'));
  }

  function deal_with_second_target(changed_obj, target) {
    var updated_target = get_target(changed_obj);
    var second_target = get_target(updated_target);

    // Just clear out the second dropdown if it exists,
    // they should start from the beginning
    if (second_target.size() > 0) {
      $('option[value!=""]', second_target).remove();

      // If the updated target has only one entry ensure that all districts
      // are loaded so that we can get those options since.
      if ($('option', updated_target).size() == 1) {
        get_options(updated_target, second_target);
      }
    }
  }

  // Retrieve options and allow a callback to be included to perform additonal
  // stuff on success
  function get_options(changed_object, target, additional_success_callback) {
    $.getJSON('/china_regions/fetch_options', {
      klass: changed_object.data('region-target-klass'),
      parent_klass: changed_object.data('region-klass'),
      parent_id: changed_object.val()
    }, function(data) {

      $('option[value!=""]', target).remove();
      $.each(data, function(index, value) {
        target.append("<option value='" + value.id + "'>" + value.name + "</option>");
      });

      typeof additional_success_callback === 'function' && additional_success_callback(changed_object, target);
    });
  }
});
