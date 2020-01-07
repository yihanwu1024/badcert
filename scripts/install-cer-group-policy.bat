for /R %%s in (.,*.cer) do (
certutil -addstore -gp -f "Disallowed" %%s
)
