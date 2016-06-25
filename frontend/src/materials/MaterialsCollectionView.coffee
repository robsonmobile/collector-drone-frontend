# Companion web-app for Elite: Dangerous, manage blueprints and material
# inventory for crafting engineer upgrades.
# Copyright (C) 2016  Frederik Schumacher
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
PagerView = require './PagerView'
MaterialView = require './MaterialView'


### MaterialsCollectionView ###
module.exports = Backbone.View.extend
    el: $("#materials-collection-view .collection-items")

    initialize: (options) ->
        {@pager} = options

        new PagerView
            el: "#materials-collection-view .pager"
            model: @pager

        @listenTo @model, "reset", @render
        @listenTo @pager, "change", @render
        return this

    render: ->
        @$el.empty()
        begin = @pager.get("offset")
        end = @pager.get("offset") + @pager.get("limit")
        @createItemView model for model, i in @model.slice begin, end
        return this

    createItemView: (model) ->
        view = new MaterialView(model: model)
        el = view.render().el
        @$el.append el
        return this
