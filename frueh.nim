import std/[envvars,strutils,sequtils]
import mummy, mummy/routers, smtp
  
# mummy boilerplate
converter toHeaders(headers: openArray[(string,string)]): HttpHeaders =
  headers.toSeq.HttpHeaders
converter toQueryParams(headers: openArray[(string,string)]): QueryParams =
  headers.toSeq.QueryParams

proc init() =
  ## config

  # server
  let port = getEnv("FRUEH_PORT", "3445").parseInt.Port
  let file = getEnv("FRUEH_FILE", "/var/lib/frueh/frueh.log")
  let host = getEnv("FRUEH_HOST", "localhost")

  # data
  let log = open(file, fmAppend)

  # mail
  let mail = newSmtp(getEnv("FRUEH_MAIL_SSL", "false").parseBool,false)
  mail.connect(getEnv("FRUEH_MAIL_HOST", "localhost"), getEnv("FRUEH_MAIL_PORT", "25").parseInt.Port)
  if existsEnv("FRUEH_MAIL_USERNAME"):
    mail.auth(getEnv("FRUEH_MAIL_USERNAME"), getEnv("FRUEH_MAIL_PASSWORD"))
  let mailTo = getEnv("FRUEH_MAIL_TO").split(":")
  let mailFrom = getEnv("FRUEH_MAIL_FROM")

  ## routes
  proc index(request: Request) =
    request.respond(200, {"Content-Type": "text/plain"}.toHeaders, "ok")

  proc save(request: Request) =
    log.writeLine(request.body)

    mail.sendMail(mailFrom, mailTo, $createMessage("New Frueh", $request.body, mailTo))
    request.respond(200, {"Content-Type": "text/plain"}.toHeaders, "Thank you!")

  ## route mapping
  var router: Router
  router.get("/", index)
  router.post("/", save)

  ## init 
  let server = newServer(router)
  server.serve(port, host)


if isMainModule:
  init()
