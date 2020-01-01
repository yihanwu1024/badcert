for /R %%s in (.,*.cer) do (
certutil -addstore -user -f "Disallowed" %%s
)
