// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require jquery3
//= require popper
//= require bootstrap
//= require activestorage
//= require action_cable
require("jquery")
require("@nathanvda/cocoon")
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "utilities/gist_loader"
import "utilities/votable"
import "utilities/commentable"
import "utilities/subscrible"
import "utilities/search_query_hint"
import "answers/answer"


Rails.start()
Turbolinks.start()
ActiveStorage.start()
