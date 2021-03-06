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
TrackBlueprintCollection = require "./TrackBlueprintCollection"
TrackMaterialCollection = require './TrackMaterialCollection'
TrackMaterial = require './TrackMaterial'


### tracking.TrackingController ###
class TrackingController
    constructor: (options) ->
        @blueprints = new TrackBlueprintCollection()
        @materials = new TrackMaterialCollection()

    trackBlueprint: (model) ->
        tracked = @blueprints.get(model.id)
        if not tracked
            tracked = @blueprints.create
                id: model.id
                quantity: 1
        else
            tracked.quantityPlus 1

        for ingredient in model.get("ingredients")
            total = tracked.get("quantity") * ingredient.quantity
            @trackMaterial ingredient.material, ingredient.quantity, total

        Backbone.trigger("action:blueprint:track")
        return tracked

    untrackBlueprint: (blueprint, quantity=null) ->
        tracked = @blueprints.get(blueprint.id)
        if tracked
            quantity ?= tracked.get "quantity"
            tracked.quantityPlus -quantity
            for ingredient in blueprint.get("ingredients")
                total = ingredient.quantity * quantity
                @untrackMaterial(ingredient.material, total)
            if tracked.get("quantity") <= 0
                tracked.destroy()

        Backbone.trigger("action:blueprint:untrack")
        return this

    trackMaterial: (material, quantity=1, total=null)->
        total ?= quantity
        tracked = @materials.get(material.id)
        if not tracked
            tracked = @materials.create
                id: material.id
                quantity: total
        else
            tracked.quantityPlus quantity
            if tracked.get("quantity") < total
                tracked.save quantity: total

        Backbone.trigger("action:material:track")
        return tracked

    untrackMaterial: (material, quantity=1) ->
        tracked = @materials.get(material.id)
        if tracked
            tracked.quantityPlus(-quantity)
            if tracked.get("quantity") <= 0
                tracked.destroy()

        Backbone.trigger("action:material:untrack")
        return this


### tracking Singleton ###
module.exports = new TrackingController
