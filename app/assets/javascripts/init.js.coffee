window.ENABLEME =
  common:
    data: {}
  users:
    data: {}

window.UTIL =
  exec: (controller, action) ->
    ns = window.ENABLEME
    if action == undefined
      action = "init"

    if controller != "" && ns[controller] && typeof ns[controller][action] == "function"
      ns[controller][action]()

  init: ->
    body = document.body
    controller = body.getAttribute "data-controller"
    action = body.getAttribute "data-action"

    window.UTIL.exec "common"
    window.UTIL.exec controller
    window.UTIL.exec controller, action

$ ->
  window.UTIL.init()