Dim pat, patparts, rxp, inp
pat = WScript.Arguments(0)
patparts = Split(pat,"/")
Set rxp = new RegExp
rxp.Global = True
rxp.Multiline = True
rxp.Pattern = patparts(1)
inp = WScript.StdIn.ReadAll
WScript.Echo rxp.Replace(inp, patparts(2))