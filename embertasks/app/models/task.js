import Model from 'ember-data/model';

export default Model.extend({
  title: DS.attr('string'),
  date: DS.attr('date'),
  description: DS.attr('string'),
  created: DS.attr('string',{
      defaultValue: function(){
          return new Date();
      }
  })
});
