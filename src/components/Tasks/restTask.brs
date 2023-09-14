sub init()
  m.messagePort = CreateObject("roMessagePort")
  m.top.observeField("request", m.messagePort)
  m.top.functionname = "makeRequest"
end sub

sub makeRequest()
  urlTransfer = createObject("roUrlTransfer")
  urlTransfer.RetainBodyOnError(true)
  urlTransfer.setPort(m.messagePort)
  urlTransfer.setCertificatesFile("common:/certs/ca-bundle.crt")
  urlTransfer.InitClientCertificates()

  while true
    msg = wait(0, m.messagePort)
    if "roUrlEvent" = type(msg)
      code = msg.getresponsecode()
      if (code > 0 and  code < 400)
        if (code > 300)
          ? "restTask Redirected!"
        end if
        response = ParseJSON(msg.getstring())
        m.top.response = {"index":m.top.request.index, "content":response}
        urlTransfer.asynccancel()
      else
        ? "API Request Error: "; msg.getfailurereason();" "; code;
        error = FormatJson({"error":msg.getfailurereason()})
        m.top.response = error
        urlTransfer.asynccancel()
      end if
    else if "request" = msg.getField()
      url = msg.getData().url
      urlTransfer.setUrl(url)
      urlTransfer.AsyncGetToString()
    end if
  end while
end sub