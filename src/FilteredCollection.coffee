# Unofficial companion web-app for Elite: Dangerous (property of Frontier
# Developments). Collector-Drone lets you manage blueprints and material
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


### FilteredCollection ###
module.exports = (source, filterModel) ->
    filtered = new source.constructor()
    filtered._source = source
    # allow this object to have it's own events
    filtered._callbacks = {}
    filtered._foobar = "filter"

    filtered.resetSource = (data)->
        filtered._source.reset(data, silent:true)
        filtered.reset source.filter(filterModel.where())

    filtered.refresh = ()->
        items = source.filter filterModel.where()
        filtered.comparator = filterModel.sort?()
        filtered.reset items

    filtered.listenTo source, "reset", ()->
        filtered.reset source.filter(filterModel.where())

    filtered.listenTo filterModel, "change", ()->
        filtered.refresh()

    filtered
