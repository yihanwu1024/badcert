for /R %%s in (.,*.cer) do (
certutil -addstore -ent -f "Disallowed" %%s
)
