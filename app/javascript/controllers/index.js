// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
//import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
//eagerLoadControllersFrom("controllers", application)

import AddressController from "./address_controller"
import MenuController from "./menu_controller"
import RoomController from "./room_controller"
application.register("address", AddressController)
application.register("menu", MenuController)
application.register("room", RoomController)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
