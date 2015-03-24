$(function(){
  $('body').on('change', '.region_select', function(event) {
    var changedObj, targetDom;
    changedObj = $(event.currentTarget);
    targetDom = $('#' + changedObj.data('region-target'));
    if (targetDom.size() > 0) {
      $.getJSON('/china_regions/fetch_options', {klass: changedObj.data('region-target-klass'), parent_klass: changedObj.data('region-klass'), parent_id: changedObj.val()}, function(data) {
        $('option[value!=""]', targetDom).remove();
        $.each(data, function(index, value) {
          targetDom.append("<option value='" + value.id + "'>" + value.name + "</option>");
        });
      })
      // just clear out the second dropdown if it exists, they should start from the beginning
      secondTargetDom = $('#' + targetDom.data('region-target'));
      if (secondTargetDom.size() > 0) {
        $('option[value!=""]', secondTargetDom).remove();
      }
    }
  });
});
