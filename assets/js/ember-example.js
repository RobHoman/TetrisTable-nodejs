window.TetrisTable = Ember.Application.create();

//TetrisTable.ApplicationAdapter = DS.FixtureAdapter.extend();
TetrisTable.ApplicationAdapter = DS.LSAdapter.extend({
    namespace: 'todos-emberjs'
});
