# c1ccccc1C(=O)NCC
import std / [strutils]
import webview
import rdkit / [molecule, descriptors, draw]

const propsTable = """<table>
    <tr><th>NumAtoms</th><th>AvgMW</th><th>ExactMW</th><th>cLogP</th></tr>
    <tr><td align="center" id="propNumAtoms"></td><td align="center" width="100px" id="propAMW"></td><td align="center" width="100px" id="propEMW"></td><td align="center" width="100px" id="propLogP"></td></tr>
    </table>"""

proc smiles_to_svg(w: Webview, smiles: string) =
  if smiles.len == 0:
    return
  let mol = molFromSmiles(smiles)
  if mol.ok:
    var svg = mol.toSVG
    svg = svg.replace("\n", "")
    discard w.eval(cstring("""document.getElementById('output').innerHTML = "$1" """ %
        [svg]))
    let
      propNumAtoms = mol.numAtoms
      propAMW = mol.avgMolWt
      propEMW = mol.exactMolWt
      propLogP = mol.cLogP
    discard w.eval(cstring("""document.getElementById('propNumAtoms').innerHTML = "$1" """ %
        [$propNumAtoms]))
    discard w.eval(cstring("""document.getElementById('propAMW').innerHTML = "$1" """ %
        [$propAMW]))
    let propEMWStr = propEMW.formatFloat(ffDecimal, 3)
    discard w.eval(cstring("""document.getElementById('propEMW').innerHTML = "$1" """ %
        [propEMWStr]))
    let propLogPStr = propLogP.formatFloat(ffDecimal, 3)
    discard w.eval(cstring("""document.getElementById('propLogP').innerHTML = "$1" """ %
        [propLogPStr]))

  else:
    discard w.eval(cstring("""document.getElementById('output').innerHTML = "Invalid Smiles!" """))
    discard w.eval(cstring("""document.getElementById('propNumAtoms').innerHTML = "$1" """ %
        [""]))
    discard w.eval(cstring("""document.getElementById('propAMW').innerHTML = "$1" """ %
        [""]))
    discard w.eval(cstring("""document.getElementById('propEMW').innerHTML = "$1" """ %
        [""]))
    discard w.eval(cstring("""document.getElementById('propLogP').innerHTML = "$1" """ %
        [""]))


let page = """data:text/html,
<!DOCTYPE html>
<html>
<body>
    <input type="text" id="smiles" placeholder="SMILES" size="70">
    <button onclick="api.showMol(document.getElementById('smiles').value)">Show Mol</button>
    <fieldset style="height: 330px; text-align: center;">
        <legend style="text-align: left;">Structure</legend>
        <p id="output">Enter Smiles</p>
    </fieldset>
    <p id="props">$1</p>
</body>
</html>""" % [propsTable]
var w = newWebView("Nim Smiles Viewer", page)
w.bindProcs("api"):
  proc showMol(smiles: string) = smiles_to_svg(w, smiles)

w.run()
w.exit()
