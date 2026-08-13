keymapWebview = nil
_prevLayer    = "home"

local function focusOrLaunch(app)
    hs.application.launchOrFocus(app)
    if keymapWebview and keymapWebview:isVisible() then
        keymapWebview:evaluateJavaScript('show("7")')
    end
end

hs.hotkey.bind({"cmd","alt","shift"}, "W", function() focusOrLaunch("WezTerm") end)
hs.hotkey.bind({"cmd","alt","shift"}, "S", function() focusOrLaunch("Slack") end)
hs.hotkey.bind({"cmd","alt","shift"}, "Z", function() focusOrLaunch("zoom.us") end)
hs.hotkey.bind({"cmd","alt","shift"}, "C", function() focusOrLaunch("Google Chrome") end)

local keymapHtml = [[<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
* { box-sizing: border-box; margin: 0; padding: 0; }
html, body { height: 100%; }
body {
  background: #111; color: #ddd;
  font-family: -apple-system, "SF Pro Text", sans-serif;
  font-size: 14px;
  display: flex; flex-direction: column; height: 100%;
  user-select: none;
}
.hdr {
  background: #0a0a0a; border-bottom: 1px solid #1e1e1e;
  padding: 10px 18px; text-align: center;
  font-size: 16px; font-weight: bold; color: #88aaff; letter-spacing: 3px;
  flex-shrink: 0; cursor: pointer;
}
.hdr:hover { color: #aabbff; }
.main { display: flex; flex: 1; overflow: hidden; }
.nav {
  width: 196px; flex-shrink: 0;
  background: #0d0d0d; border-right: 1px solid #1e1e1e;
  overflow-y: auto; padding: 12px 0;
}
.nav-lbl { font-size: 10px; color: #333; letter-spacing: 2px; text-transform: uppercase; padding: 4px 14px 8px; }
.ni { display: flex; align-items: center; gap: 8px; padding: 7px 12px; cursor: pointer; border-left: 3px solid transparent; }
.ni:hover { background: #181818; }
.ni.sel { border-left-color: var(--lc); background: var(--lb); }
.ni.sub { padding-left: 28px; }
.lbadge {
  font-family: "SF Mono", Menlo, monospace; font-size: 11px; font-weight: bold;
  padding: 2px 7px; border-radius: 3px;
  background: var(--lb); color: var(--lc); border: 1px solid var(--lc); white-space: nowrap;
}
.lhow { font-size: 11px; color: #444; }
.L0 { --lc: #aaaaaa; --lb: #1e1e1e; }
.L1 { --lc: #ff9944; --lb: #1e1100; }
.L2 { --lc: #4a9eff; --lb: #001525; }
.L3 { --lc: #ffbb66; --lb: #1e1500; }
.L4 { --lc: #88ccff; --lb: #001122; }
.L5 { --lc: #ff6688; --lb: #200012; }
.L6 { --lc: #44ff99; --lb: #002012; }
.L7 { --lc: #bb88ff; --lb: #160022; }
.content { flex: 1; overflow: auto; padding: 18px 22px; }
.view { display: none; }
/* HOME */
.thumb-label { font-size: 11px; color: #3a3a3a; letter-spacing: 2px; text-transform: uppercase; margin-bottom: 10px; text-align: center; }
.thumb-row { display: flex; justify-content: center; align-items: flex-start; gap: 8px; margin-bottom: 20px; }
.tgap { width: 26px; flex-shrink: 0; }
.tkey { background: #1a1a1a; border: 2px solid var(--lc); border-bottom: 4px solid var(--lbb); border-radius: 7px; padding: 8px 10px 6px; text-align: center; min-width: 82px; cursor: pointer; }
.tkey:hover { background: #222; }
.kn { font-weight: bold; font-size: 15px; color: #eee; margin-bottom: 4px; font-family: "SF Mono", Menlo, monospace; }
.kt { font-size: 11px; color: #666; }
.kh { font-size: 11px; color: var(--lc); font-weight: bold; margin-top: 2px; }
.tree-label { font-size: 11px; color: #3a3a3a; letter-spacing: 2px; text-transform: uppercase; margin-bottom: 8px; }
.tree { display: flex; flex-direction: column; gap: 4px; }
.tr { display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 2px 0; }
.tr:hover .tbadge { filter: brightness(1.2); }
.tr.tsub { padding-left: 22px; }
.tbadge { font-family: "SF Mono", Menlo, monospace; font-size: 13px; font-weight: bold; padding: 3px 10px; border-radius: 4px; background: var(--lb); color: var(--lc); border: 1px solid var(--lc); min-width: 80px; text-align: center; }
.thow { font-size: 13px; color: #777; }
.thow b { color: #bbb; }
/* LAYER DETAIL */
.dhdr { display: flex; align-items: center; gap: 14px; margin-bottom: 16px; padding-bottom: 14px; border-bottom: 1px solid #1e1e1e; }
.dnum { font-family: "SF Mono", Menlo, monospace; font-size: 22px; font-weight: bold; padding: 6px 14px; border-radius: 6px; background: var(--lb); color: var(--lc); border: 2px solid var(--lc); }
.dname { font-size: 22px; font-weight: bold; color: #eee; }
.dhow { font-size: 13px; color: #666; margin-top: 4px; }
.notes { list-style: none; }
.notes li { font-size: 13px; color: #666; padding: 3px 0 3px 16px; position: relative; }
.notes li::before { content: '·'; position: absolute; left: 5px; color: #3a3a3a; }
.notes li b { color: #999; }
/* KEY GRID */
.kb { display:flex; flex-direction:column; gap:5px; margin-bottom:14px; }
.kb-row { display:flex; gap:5px; align-items:stretch; }
.kb-sep { width:18px; flex-shrink:0; }
.kb-center { justify-content:center; margin-top:4px; }
.kb-key { background:#1c1c1c; border:1px solid #333; border-bottom:3px solid #222; border-radius:5px; padding:5px 6px 4px; text-align:center; min-width:52px; font-family:"SF Mono",Menlo,monospace; }
.kb-key .kl { font-size:13px; color:#ccc; display:block; font-weight:bold; }
.kb-key .km { font-size:9px; color:#555; display:block; margin-top:1px; }
.kb-key.pressed { background:#0d2a45 !important; border-color:#4a9eff !important; border-bottom-color:#1a5080 !important; }
.kb-key.pressed .kl { color:#88cfff !important; }
.kb-extra { min-width:60px; }
.kb-thumb { min-width:68px; }
.kb-key.active { border-color:var(--lc); }
.kb-key.active .kl { color:var(--lc); }
.kb-key.dim { opacity:0.18; }
.kb-key.inherited { opacity:0.38; border-style:dashed; }
</style>
<script>
var _pt = {};
function pressKey(id) {
  var el = document.getElementById(id);
  if (!el) return;
  el.classList.add('pressed');
  clearTimeout(_pt[id]);
  _pt[id] = setTimeout(function() { el.classList.remove('pressed'); }, 200);
}
function show(id) {
  document.querySelectorAll('.view').forEach(function(el) { el.style.display = 'none'; });
  document.getElementById('v-' + id).style.display = 'block';
  document.querySelectorAll('.ni').forEach(function(el) {
    el.classList.toggle('sel', el.dataset.l === id);
  });
}
window.onload = function() { show('home'); };
</script>
</head>
<body>
<div class="hdr" onclick="show('home')">CORNE — LAYER REFERENCE</div>
<div class="main">
<nav class="nav">
  <div class="nav-lbl">Capas</div>
  <div class="ni L0" data-l="0" onclick="show('0')"><span class="lbadge L0">0 Base</span><span class="lhow">siempre</span></div>
  <div class="ni L1" data-l="1" onclick="show('1')"><span class="lbadge L1">1 Sym</span><span class="lhow">MO1</span></div>
  <div class="ni L2" data-l="2" onclick="show('2')"><span class="lbadge L2">2 Nav</span><span class="lhow">MO2</span></div>
  <div class="ni sub L3" data-l="3" onclick="show('3')"><span class="lbadge L3">3 Sys</span><span class="lhow">SPC+MO2</span></div>
  <div class="ni sub L4" data-l="4" onclick="show('4')"><span class="lbadge L4">4 Fn</span><span class="lhow">BSPC</span></div>
  <div class="ni sub L7" data-l="7" onclick="show('7')"><span class="lbadge L7">7 Apps</span><span class="lhow">MO7</span></div>
  <div class="ni L5" data-l="5" onclick="show('5')"><span class="lbadge L5">5 Mac</span><span class="lhow">RET/L5</span></div>
  <div class="ni L6" data-l="6" onclick="show('6')"><span class="lbadge L6">6 Lang</span><span class="lhow">CW/L6</span></div>
</nav>
<div class="content">

<!-- HOME -->
<div id="v-home" class="view">
  <div class="thumb-label">◄ IZQUIERDO ──────────────────── DERECHO ►</div>
  <div class="thumb-row">
    <div class="tkey L6" style="--lbb:#22aa66" onclick="show('6')"><div class="kn">CW/L6</div><div class="kt">tap: CapsWord</div><div class="kh">hold → Lang 6</div></div>
    <div class="tkey L7" style="--lbb:#5533aa" onclick="show('7')"><div class="kn">MO7</div><div class="kt">hold only</div><div class="kh">hold → Apps 7</div></div>
    <div class="tkey" style="--lc:#555;--lbb:#333"><div class="kn">SPACE</div><div class="kt">—</div><div class="kh" style="color:#333">—</div></div>
    <div class="tgap"></div>
    <div class="tkey L2" style="--lbb:#1a4488" onclick="show('2')"><div class="kn">MO2</div><div class="kt">solo: nada</div><div class="kh">hold → Nav 2</div></div>
    <div class="tkey L1" style="--lbb:#884422" onclick="show('1')"><div class="kn">MO1</div><div class="kt">solo: nada</div><div class="kh">hold → Sym 1</div></div>
    <div class="tkey L5" style="--lbb:#882244" onclick="show('5')"><div class="kn">RET/L5</div><div class="kt">tap: ↵ RET</div><div class="kh">hold → Mac 5</div></div>
  </div>
  <div class="tree-label">Árbol de capas — click para ver layout</div>
  <div class="tree">
    <div class="tr L0" onclick="show('0')"><span class="tbadge L0">Base 0</span><span class="thow">siempre activo</span></div>
    <div class="tr L1" onclick="show('1')"><span class="tbadge L1">Sym 1</span><span class="thow">hold <b>MO1</b> (der-med)</span></div>
    <div class="tr L2" onclick="show('2')"><span class="tbadge L2">Nav 2</span><span class="thow">hold <b>MO2</b> (der-int)</span></div>
    <div class="tr tsub L3" onclick="show('3')"><span class="tbadge L3">Sys 3</span><span class="thow">hold <b>SPC + MO2</b> combo</span></div>
    <div class="tr tsub L4" onclick="show('4')"><span class="tbadge L4">Fn 4</span><span class="thow">hold <b>BSPC</b></span></div>
    <div class="tr tsub L7" onclick="show('7')"><span class="tbadge L7">Apps 7</span><span class="thow">hold <b>MO7</b> (izq-med)</span></div>
    <div class="tr L5" onclick="show('5')"><span class="tbadge L5">Mac 5</span><span class="thow">hold <b>RET/L5</b> (der-ext)</span></div>
    <div class="tr L6" onclick="show('6')"><span class="tbadge L6">Lang 6</span><span class="thow">hold <b>CW/L6</b> (izq-ext)</span></div>
  </div>
  <div style="text-align:center;color:#252525;font-size:11px;margin-top:18px">⌥⌘⇧H · Layer 7 tecla M · click título para volver aquí</div>
</div>

<!-- LAYER 0 -->
<div id="v-0" class="view L0">
  <div class="dhdr L0"><div class="dnum L0">0</div><div><div class="dname">Base</div><div class="dhow">Colemak-DH + HRM — siempre activo</div></div></div>
  <div class="kb">
    <div class="kb-row">
      <div class="kb-key kb-extra" id="l0-k-esc"><span class="kl">gresc</span><span class="km">ESC·`~`</span></div>
      <div class="kb-key" id="l0-k-q"><span class="kl">Q</span></div>
      <div class="kb-key" id="l0-k-w"><span class="kl">W</span></div>
      <div class="kb-key" id="l0-k-f"><span class="kl">F</span></div>
      <div class="kb-key" id="l0-k-p"><span class="kl">P</span></div>
      <div class="kb-key" id="l0-k-b"><span class="kl">B</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key" id="l0-k-j"><span class="kl">J</span></div>
      <div class="kb-key" id="l0-k-l"><span class="kl">L</span></div>
      <div class="kb-key" id="l0-k-u"><span class="kl">U</span></div>
      <div class="kb-key" id="l0-k-y"><span class="kl">Y</span></div>
      <div class="kb-key" id="l0-k-semi"><span class="kl">;</span></div>
      <div class="kb-key kb-extra active L4" id="l0-k-bspc"><span class="kl">⌫</span><span class="km">hold→Fn4</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra" id="l0-k-tab"><span class="kl">TAB</span></div>
      <div class="kb-key" id="l0-k-a"><span class="kl">A</span><span class="km">⌘</span></div>
      <div class="kb-key" id="l0-k-r"><span class="kl">R</span><span class="km">⌥</span></div>
      <div class="kb-key" id="l0-k-s"><span class="kl">S</span><span class="km">⌃</span></div>
      <div class="kb-key" id="l0-k-t"><span class="kl">T</span><span class="km">⇧</span></div>
      <div class="kb-key" id="l0-k-g"><span class="kl">G</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key" id="l0-k-m"><span class="kl">M</span></div>
      <div class="kb-key" id="l0-k-n"><span class="kl">N</span><span class="km">⇧</span></div>
      <div class="kb-key" id="l0-k-e"><span class="kl">E</span><span class="km">⌃</span></div>
      <div class="kb-key" id="l0-k-i"><span class="kl">I</span><span class="km">⌥</span></div>
      <div class="kb-key" id="l0-k-o"><span class="kl">O</span><span class="km">⌘</span></div>
      <div class="kb-key" id="l0-k-apos"><span class="kl">'</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra" id="l0-k-ctrl"><span class="kl">CW/⌘</span><span class="km">CapsWord·⌘</span></div>
      <div class="kb-key" id="l0-k-z"><span class="kl">Z</span></div>
      <div class="kb-key" id="l0-k-x"><span class="kl">X</span></div>
      <div class="kb-key" id="l0-k-c"><span class="kl">C</span></div>
      <div class="kb-key" id="l0-k-d"><span class="kl">D</span></div>
      <div class="kb-key" id="l0-k-v"><span class="kl">V</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key" id="l0-k-k"><span class="kl">K</span></div>
      <div class="kb-key" id="l0-k-h"><span class="kl">H</span></div>
      <div class="kb-key" id="l0-k-comma"><span class="kl">,</span></div>
      <div class="kb-key" id="l0-k-dot"><span class="kl">.</span></div>
      <div class="kb-key" id="l0-k-slash"><span class="kl">/</span></div>
      <div class="kb-key kb-extra" id="l0-k-ret"><span class="kl">REPT</span></div>
    </div>
    <div class="kb-row kb-center">
      <div class="kb-key kb-thumb active L6" id="l0-k-cpsw"><span class="kl">CW/L6</span><span class="km">CW·Lang6</span></div>
      <div class="kb-key kb-thumb active L7" id="l0-k-gui"><span class="kl">MO7</span><span class="km">→Apps7</span></div>
      <div class="kb-key kb-thumb" id="l0-k-mo7"><span class="kl">SPACE</span><span class="km">—</span></div>
      <div class="kb-sep" style="width:24px"></div>
      <div class="kb-key kb-thumb active L5" id="l0-k-mo2"><span class="kl">RET/L5</span><span class="km">↵·Mac5</span></div>
      <div class="kb-key kb-thumb active L2" id="l0-k-mo1"><span class="kl">MO2</span><span class="km">Nav2</span></div>
      <div class="kb-key kb-thumb active L1" id="l0-k-sym5"><span class="kl">MO1</span><span class="km">Sym1</span></div>
    </div>
  </div>
  <ul class="notes">
    <li><b>gresc</b>: tap=ESC, Shift+tap=`~`</li>
    <li><b>CW/L6</b>: tap=CapsWord / hold=Layer 6 (Lang)</li>
    <li><b>MO7</b>: hold only → Layer 7 (Apps) — ⌃ Ctrl via HRM en S</li>
    <li><b>RET/L5</b>: tap=↵ RET / hold=Layer 5 (Mac) — inner right thumb</li>
    <li><b>CW/⌘</b>: tap=CapsWord / hold=⌘ GUI</li>
    <li><b>BSPC</b>: tap=⌫ / hold=Layer 4 (Fn)</li>
    <li><b>HRM</b>: tap=letra, hold=modificador (GUI/ALT/CTL/SHF)</li>
  </ul>
</div>

<!-- LAYER 1 -->
<div id="v-1" class="view L1">
  <div class="dhdr L1"><div class="dnum L1">1</div><div><div class="dname">Sym</div><div class="dhow">hold MO1 (der-med)</div></div></div>
  <div class="kb">
    <div class="kb-row">
      <div class="kb-key kb-extra active L1" id="l1-k-esc"><span class="kl">REPT</span></div>
      <div class="kb-key active L1" id="l1-k-q"><span class="kl">1/!</span></div>
      <div class="kb-key active L1" id="l1-k-w"><span class="kl">2/@</span></div>
      <div class="kb-key active L1" id="l1-k-f"><span class="kl">3/#</span></div>
      <div class="kb-key active L1" id="l1-k-p"><span class="kl">4/$</span></div>
      <div class="kb-key active L1" id="l1-k-b"><span class="kl">5/%</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L1" id="l1-k-j"><span class="kl">6/^</span></div>
      <div class="kb-key active L1" id="l1-k-l"><span class="kl">7/&amp;</span></div>
      <div class="kb-key active L1" id="l1-k-u"><span class="kl">8/*</span></div>
      <div class="kb-key active L1" id="l1-k-y"><span class="kl">9/(</span></div>
      <div class="kb-key active L1" id="l1-k-semi"><span class="kl">0/)</span></div>
      <div class="kb-key kb-extra active L1" id="l1-k-bspc"><span class="kl">DEL</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra active L1" id="l1-k-tab"><span class="kl">TAB</span></div>
      <div class="kb-key active L1" id="l1-k-a"><span class="kl">!</span></div>
      <div class="kb-key active L1" id="l1-k-r"><span class="kl">@</span></div>
      <div class="kb-key active L1" id="l1-k-s"><span class="kl">#</span></div>
      <div class="kb-key active L1" id="l1-k-t"><span class="kl">$</span></div>
      <div class="kb-key active L1" id="l1-k-g"><span class="kl">%</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L1" id="l1-k-m"><span class="kl">-</span></div>
      <div class="kb-key active L1" id="l1-k-n"><span class="kl">=</span></div>
      <div class="kb-key active L1" id="l1-k-e"><span class="kl">^</span></div>
      <div class="kb-key active L1" id="l1-k-i"><span class="kl">|</span></div>
      <div class="kb-key active L1" id="l1-k-o"><span class="kl">\</span></div>
      <div class="kb-key active L1" id="l1-k-apos"><span class="kl">`</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra active L1" id="l1-k-ctrl"><span class="kl">SK</span><span class="km">⇧Sticky</span></div>
      <div class="kb-key active L1" id="l1-k-z"><span class="kl">&amp;</span></div>
      <div class="kb-key active L1" id="l1-k-x"><span class="kl">*</span></div>
      <div class="kb-key active L1" id="l1-k-c"><span class="kl">(</span></div>
      <div class="kb-key active L1" id="l1-k-d"><span class="kl">)</span></div>
      <div class="kb-key active L1" id="l1-k-v"><span class="kl">_</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L1" id="l1-k-k"><span class="kl">[</span></div>
      <div class="kb-key active L1" id="l1-k-h"><span class="kl">]</span></div>
      <div class="kb-key active L1" id="l1-k-comma"><span class="kl">{</span></div>
      <div class="kb-key active L1" id="l1-k-dot"><span class="kl">}</span></div>
      <div class="kb-key active L1" id="l1-k-slash"><span class="kl">+</span></div>
      <div class="kb-key kb-extra active L1" id="l1-k-ret"><span class="kl">↵</span></div>
    </div>
    <div class="kb-row kb-center">
      <div class="kb-key kb-thumb inherited" id="l1-k-cpsw"><span class="kl">CW/L6</span></div>
      <div class="kb-key kb-thumb inherited" id="l1-k-gui"><span class="kl">MO7</span></div>
      <div class="kb-key kb-thumb active L1" id="l1-k-mo7"><span class="kl">SPACE</span></div>
      <div class="kb-sep" style="width:24px"></div>
      <div class="kb-key kb-thumb active L3" id="l1-k-mo2"><span class="kl">MO3</span><span class="km">Sys3</span></div>
      <div class="kb-key kb-thumb active L1" id="l1-k-mo1"><span class="kl">TOG1</span><span class="km">lock</span></div>
      <div class="kb-key kb-thumb dim" id="l1-k-sym5"><span class="kl">[hld]</span><span class="km">Sym1</span></div>
    </div>
  </div>
  <ul class="notes">
    <li><b>REPT</b>: repite el último key en cualquier layer</li>
    <li><b>1/!</b> … <b>0/)</b>: tap=número, hold=símbolo</li>
    <li><b>SK</b>: Sticky Shift (tap=1 char, doble=sticky, triple=CapsLock)</li>
    <li><b>TOG1</b>: bloquea/desbloquea Layer 1 — hold MO1 + tap MO2</li>
  </ul>
</div>

<!-- LAYER 2 -->
<div id="v-2" class="view L2">
  <div class="dhdr L2"><div class="dnum L2">2</div><div><div class="dname">Nav</div><div class="dhow">hold MO2 (der-med)</div></div></div>
  <div class="kb">
    <div class="kb-row">
      <div class="kb-key kb-extra active L2" id="l2-k-esc"><span class="kl">SCRL↑</span></div>
      <div class="kb-key dim" id="l2-k-q"><span class="kl">·</span></div>
      <div class="kb-key active L2" id="l2-k-w"><span class="kl">M↑</span></div>
      <div class="kb-key dim" id="l2-k-f"><span class="kl">·</span></div>
      <div class="kb-key active L2" id="l2-k-p"><span class="kl">LCLK</span></div>
      <div class="kb-key dim" id="l2-k-b"><span class="kl">·</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L2" id="l2-k-j"><span class="kl">⇧HOME</span><span class="km">sel inicio</span></div>
      <div class="kb-key active L2" id="l2-k-l"><span class="kl">WJ←</span><span class="km">⌥←</span></div>
      <div class="kb-key active L2" id="l2-k-u"><span class="kl">↑</span></div>
      <div class="kb-key active L2" id="l2-k-y"><span class="kl">WJ→</span><span class="km">⌥→</span></div>
      <div class="kb-key active L2" id="l2-k-semi"><span class="kl">⇧END</span><span class="km">sel fin</span></div>
      <div class="kb-key kb-extra active L2" id="l2-k-bspc"><span class="kl">⌫</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra active L2" id="l2-k-tab"><span class="kl">SCRL↓</span></div>
      <div class="kb-key active L2" id="l2-k-a"><span class="kl">M←</span></div>
      <div class="kb-key active L2" id="l2-k-r"><span class="kl">M↓</span></div>
      <div class="kb-key active L2" id="l2-k-s"><span class="kl">M→</span></div>
      <div class="kb-key active L2" id="l2-k-t"><span class="kl">MCLK</span></div>
      <div class="kb-key dim" id="l2-k-g"><span class="kl">·</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key dim" id="l2-k-m"><span class="kl">·</span></div>
      <div class="kb-key active L2" id="l2-k-n"><span class="kl">←</span></div>
      <div class="kb-key active L2" id="l2-k-e"><span class="kl">↓</span></div>
      <div class="kb-key active L2" id="l2-k-i"><span class="kl">→</span></div>
      <div class="kb-key active L2" id="l2-k-o"><span class="kl">HOME</span></div>
      <div class="kb-key active L2" id="l2-k-apos"><span class="kl">PGUP</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra active L2" id="l2-k-ctrl"><span class="kl">SCRL←</span></div>
      <div class="kb-key active L2" id="l2-k-z"><span class="kl">SCRL→</span></div>
      <div class="kb-key dim" id="l2-k-x"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l2-k-c"><span class="kl">·</span></div>
      <div class="kb-key active L2" id="l2-k-d"><span class="kl">RCLK</span></div>
      <div class="kb-key dim" id="l2-k-v"><span class="kl">·</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L2" id="l2-k-k"><span class="kl">SEL↑</span><span class="km">⇧↑</span></div>
      <div class="kb-key active L2" id="l2-k-h"><span class="kl">SEL←</span><span class="km">⇧←</span></div>
      <div class="kb-key active L2" id="l2-k-comma"><span class="kl">SEL↓</span><span class="km">⇧↓</span></div>
      <div class="kb-key active L2" id="l2-k-dot"><span class="kl">SEL→</span><span class="km">⇧→</span></div>
      <div class="kb-key active L2" id="l2-k-slash"><span class="kl">END</span></div>
      <div class="kb-key kb-extra active L2" id="l2-k-ret"><span class="kl">PGDN</span></div>
    </div>
    <div class="kb-row kb-center">
      <div class="kb-key kb-thumb dim" id="l2-k-cpsw"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb dim" id="l2-k-gui"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb dim" id="l2-k-mo7"><span class="kl">·</span></div>
      <div class="kb-sep" style="width:24px"></div>
      <div class="kb-key kb-thumb active L4" id="l2-k-mo2"><span class="kl">MO4</span><span class="km">→Fn</span></div>
      <div class="kb-key kb-thumb dim" id="l2-k-mo1"><span class="kl">[hld]</span><span class="km">Nav2</span></div>
      <div class="kb-key kb-thumb dim" id="l2-k-sym5"><span class="kl">·</span></div>
    </div>
  </div>
  <ul class="notes">
    <li>Izquierdo: mouse (movimiento, scroll, clics)</li>
    <li>Derecho fila 1: <b>⇧HOME</b>=sel inicio línea · <b>WJ←/→</b>=⌥←/→ (word jump) · <b>⇧END</b>=sel fin línea</li>
    <li>Derecho fila 3: <b>SEL↑/←/↓/→</b>=⇧+flecha</li>
    <li><b>Layer 7 Apps</b>: hold MO7 (izq-med)</li>
  </ul>
</div>

<!-- LAYER 3 -->
<div id="v-3" class="view L3">
  <div class="dhdr L3"><div class="dnum L3">3</div><div><div class="dname">Sys</div><div class="dhow">combo SPC + MO2 (thumbs internos)</div></div></div>
  <div class="kb">
    <div class="kb-row">
      <div class="kb-key kb-extra active L3" id="l3-k-esc"><span class="kl">BTCLR</span></div>
      <div class="kb-key active L3" id="l3-k-q"><span class="kl">PRV</span></div>
      <div class="kb-key active L3" id="l3-k-w"><span class="kl">PLAY</span></div>
      <div class="kb-key active L3" id="l3-k-f"><span class="kl">NXT</span></div>
      <div class="kb-key active L3" id="l3-k-p"><span class="kl">BLE</span></div>
      <div class="kb-key active L3" id="l3-k-b"><span class="kl">USB</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L3" id="l3-k-j"><span class="kl">BRI-</span></div>
      <div class="kb-key active L3" id="l3-k-l"><span class="kl">BRI+</span></div>
      <div class="kb-key dim" id="l3-k-u"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l3-k-y"><span class="kl">·</span></div>
      <div class="kb-key active L3" id="l3-k-semi"><span class="kl">BL-TG</span></div>
      <div class="kb-key kb-extra active L3" id="l3-k-bspc"><span class="kl">RGB-T</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra active L3" id="l3-k-tab"><span class="kl">SOFF</span></div>
      <div class="kb-key active L3" id="l3-k-a"><span class="kl">BT0</span></div>
      <div class="kb-key active L3" id="l3-k-r"><span class="kl">BT1</span></div>
      <div class="kb-key active L3" id="l3-k-s"><span class="kl">BT2</span></div>
      <div class="kb-key active L3" id="l3-k-t"><span class="kl">VOL-</span></div>
      <div class="kb-key active L3" id="l3-k-g"><span class="kl">VOL+</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L3" id="l3-k-m"><span class="kl">RGB+</span></div>
      <div class="kb-key dim" id="l3-k-n"><span class="kl">·</span></div>
      <div class="kb-key active L3" id="l3-k-e"><span class="kl">BL-</span></div>
      <div class="kb-key active L3" id="l3-k-i"><span class="kl">BL+</span></div>
      <div class="kb-key active L3" id="l3-k-o"><span class="kl">RGB-</span></div>
      <div class="kb-key active L3" id="l3-k-apos"><span class="kl">RGB++</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra active L3" id="l3-k-ctrl"><span class="kl">BOOT</span></div>
      <div class="kb-key active L3" id="l3-k-z"><span class="kl">BT3</span></div>
      <div class="kb-key active L3" id="l3-k-x"><span class="kl">BT4</span></div>
      <div class="kb-key active L3" id="l3-k-c"><span class="kl">BT5</span></div>
      <div class="kb-key active L3" id="l3-k-d"><span class="kl">MUTE</span></div>
      <div class="kb-key active L3" id="l3-k-v"><span class="kl">LCK</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L3" id="l3-k-k"><span class="kl">🟢</span></div>
      <div class="kb-key active L3" id="l3-k-h"><span class="kl">🔴</span></div>
      <div class="kb-key active L3" id="l3-k-comma"><span class="kl">🔵</span></div>
      <div class="kb-key active L3" id="l3-k-dot"><span class="kl">🟡</span></div>
      <div class="kb-key dim" id="l3-k-slash"><span class="kl">·</span></div>
      <div class="kb-key kb-extra dim" id="l3-k-ret"><span class="kl">·</span></div>
    </div>
    <div class="kb-row kb-center">
      <div class="kb-key kb-thumb active L3" id="l3-k-cpsw"><span class="kl">⌘</span></div>
      <div class="kb-key kb-thumb dim" id="l3-k-gui"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb dim" id="l3-k-mo7"><span class="kl">[hld]</span><span class="km">SPC</span></div>
      <div class="kb-sep" style="width:24px"></div>
      <div class="kb-key kb-thumb dim" id="l3-k-mo2"><span class="kl">[hld]</span><span class="km">MO2</span></div>
      <div class="kb-key kb-thumb dim" id="l3-k-mo1"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb active L3" id="l3-k-sym5"><span class="kl">RALT</span></div>
    </div>
  </div>
  <ul class="notes">
    <li><b>BT0-5</b>: perfiles Bluetooth / <b>BTCLR</b>: limpiar perfil actual</li>
    <li><b>BLE/USB</b>: modo de conexión / <b>BRI-/+</b>: brillo de pantalla</li>
    <li><b>SOFF</b>: deep sleep (wakeup: doble-tap reset) / <b>BOOT</b>: modo bootloader</li>
  </ul>
</div>

<!-- LAYER 4 -->
<div id="v-4" class="view L4">
  <div class="dhdr L4"><div class="dnum L4">4</div><div><div class="dname">Fn</div><div class="dhow">hold BSPC (top-der)</div></div></div>
  <div class="kb">
    <div class="kb-row">
      <div class="kb-key kb-extra active L4" id="l4-k-esc"><span class="kl">F1</span></div>
      <div class="kb-key active L4" id="l4-k-q"><span class="kl">F2</span></div>
      <div class="kb-key active L4" id="l4-k-w"><span class="kl">F3</span></div>
      <div class="kb-key active L4" id="l4-k-f"><span class="kl">F4</span></div>
      <div class="kb-key active L4" id="l4-k-p"><span class="kl">F5</span></div>
      <div class="kb-key active L4" id="l4-k-b"><span class="kl">F6</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L4" id="l4-k-j"><span class="kl">F7</span></div>
      <div class="kb-key active L4" id="l4-k-l"><span class="kl">F8</span></div>
      <div class="kb-key active L4" id="l4-k-u"><span class="kl">F9</span></div>
      <div class="kb-key active L4" id="l4-k-y"><span class="kl">F10</span></div>
      <div class="kb-key active L4" id="l4-k-semi"><span class="kl">F11</span></div>
      <div class="kb-key kb-extra active L4" id="l4-k-bspc"><span class="kl">F12</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra dim" id="l4-k-tab"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l4-k-a"><span class="kl">·</span></div><div class="kb-key dim" id="l4-k-r"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l4-k-s"><span class="kl">·</span></div><div class="kb-key dim" id="l4-k-t"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l4-k-g"><span class="kl">·</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key dim" id="l4-k-m"><span class="kl">·</span></div><div class="kb-key dim" id="l4-k-n"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l4-k-e"><span class="kl">·</span></div><div class="kb-key dim" id="l4-k-i"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l4-k-o"><span class="kl">·</span></div><div class="kb-key dim" id="l4-k-apos"><span class="kl">·</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra dim" id="l4-k-ctrl"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l4-k-z"><span class="kl">·</span></div><div class="kb-key dim" id="l4-k-x"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l4-k-c"><span class="kl">·</span></div><div class="kb-key dim" id="l4-k-d"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l4-k-v"><span class="kl">·</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key dim" id="l4-k-k"><span class="kl">·</span></div><div class="kb-key dim" id="l4-k-h"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l4-k-comma"><span class="kl">·</span></div><div class="kb-key dim" id="l4-k-dot"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l4-k-slash"><span class="kl">·</span></div><div class="kb-key kb-extra dim" id="l4-k-ret"><span class="kl">·</span></div>
    </div>
    <div class="kb-row kb-center">
      <div class="kb-key kb-thumb dim" id="l4-k-cpsw"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb dim" id="l4-k-gui"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb dim" id="l4-k-mo7"><span class="kl">·</span></div>
      <div class="kb-sep" style="width:24px"></div>
      <div class="kb-key kb-thumb dim" id="l4-k-mo2"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb dim" id="l4-k-mo1"><span class="kl">[hld]</span><span class="km">Fn4</span></div>
      <div class="kb-key kb-thumb dim" id="l4-k-sym5"><span class="kl">·</span></div>
    </div>
  </div>
  <ul class="notes">
    <li>F1–F12 en la fila superior completa</li>
    <li>Activación: hold <b>BSPC</b> (top-der)</li>
  </ul>
</div>

<!-- LAYER 5 -->
<div id="v-5" class="view L5">
  <div class="dhdr L5"><div class="dnum L5">5</div><div><div class="dname">Mac</div><div class="dhow">hold RET/L5 (der-ext)</div></div></div>
  <div class="kb">
    <div class="kb-row">
      <div class="kb-key kb-extra active L5" id="l5-k-esc"><span class="kl">DSK1</span></div>
      <div class="kb-key active L5" id="l5-k-q"><span class="kl">DSK2</span></div>
      <div class="kb-key active L5" id="l5-k-w"><span class="kl">DSK3</span></div>
      <div class="kb-key active L5" id="l5-k-f"><span class="kl">DSK4</span></div>
      <div class="kb-key active L5" id="l5-k-p"><span class="kl">DSK5</span></div>
      <div class="kb-key active L5" id="l5-k-b"><span class="kl">HDE</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L5" id="l5-k-j"><span class="kl">WIN←</span></div>
      <div class="kb-key active L5" id="l5-k-l"><span class="kl">WIN→</span></div>
      <div class="kb-key active L5" id="l5-k-u"><span class="kl">WIN↑</span></div>
      <div class="kb-key active L5" id="l5-k-y"><span class="kl">WIN↓</span></div>
      <div class="kb-key active L5" id="l5-k-semi"><span class="kl">MAX</span></div>
      <div class="kb-key kb-extra active L5" id="l5-k-bspc"><span class="kl">RST</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra active L5" id="l5-k-tab"><span class="kl">FQ</span></div>
      <div class="kb-key active L5" id="l5-k-a"><span class="kl">SS📋</span></div>
      <div class="kb-key active L5" id="l5-k-r"><span class="kl">SS⌘4</span></div>
      <div class="kb-key active L5" id="l5-k-s"><span class="kl">UND</span></div>
      <div class="kb-key active L5" id="l5-k-t"><span class="kl">RED</span></div>
      <div class="kb-key active L5" id="l5-k-g"><span class="kl">MCrl</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L5" id="l5-k-m"><span class="kl">BCK</span></div>
      <div class="kb-key active L5" id="l5-k-n"><span class="kl">CTR</span></div>
      <div class="kb-key active L5" id="l5-k-e"><span class="kl">dt</span><span class="km">tmx detach</span></div>
      <div class="kb-key active L5" id="l5-k-i"><span class="kl">zm</span><span class="km">tmx zoom</span></div>
      <div class="kb-key active L5" id="l5-k-o"><span class="kl">FWD</span></div>
      <div class="kb-key dim" id="l5-k-apos"><span class="kl">·</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra dim" id="l5-k-ctrl"><span class="kl">·</span></div>
      <div class="kb-key active L5" id="l5-k-z"><span class="kl">DSK←</span></div>
      <div class="kb-key active L5" id="l5-k-x"><span class="kl">DSK→</span></div>
      <div class="kb-key active L5" id="l5-k-c"><span class="kl">Exposé</span></div>
      <div class="kb-key active L5" id="l5-k-d"><span class="kl">MW←</span></div>
      <div class="kb-key active L5" id="l5-k-v"><span class="kl">MW→</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L5" id="l5-k-k"><span class="kl">DISP←</span></div>
      <div class="kb-key active L5" id="l5-k-h"><span class="kl">DISP→</span></div>
      <div class="kb-key active L5" id="l5-k-comma"><span class="kl">nw</span><span class="km">tmx new</span></div>
      <div class="kb-key active L5" id="l5-k-dot"><span class="kl">%</span><span class="km">tmx sph</span></div>
      <div class="kb-key active L5" id="l5-k-slash"><span class="kl">"</span><span class="km">tmx spv</span></div>
      <div class="kb-key kb-extra dim" id="l5-k-ret"><span class="kl">·</span></div>
    </div>
    <div class="kb-row kb-center">
      <div class="kb-key kb-thumb dim" id="l5-k-cpsw"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb" id="l5-k-gui"><span class="kl">⌘</span></div>
      <div class="kb-key kb-thumb active L5" id="l5-k-mo7"><span class="kl">SPACE</span></div>
      <div class="kb-sep" style="width:24px"></div>
      <div class="kb-key kb-thumb dim" id="l5-k-mo2"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb dim" id="l5-k-mo1"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb dim" id="l5-k-sym5"><span class="kl">[hld]</span><span class="km">RET/L5</span></div>
    </div>
  </div>
  <ul class="notes">
    <li>Izquierdo: escritorios (DSK1-5), screenshots, undo/redo, Mission Control</li>
    <li>Derecho: Rectangle (WIN←→↑↓ MAX RST), browser nav, tmux</li>
    <li><b>DISP←/→</b>: mover ventana al display anterior/siguiente (Rectangle ⌥⌘⇧←/→)</li>
    <li><b>FQ</b>=Force Quit, <b>MCrl</b>=Mission Control, <b>BCK/FWD</b>=⌘[/⌘]</li>
  </ul>
</div>

<!-- LAYER 6 -->
<div id="v-6" class="view L6">
  <div class="dhdr L6"><div class="dnum L6">6</div><div><div class="dname">Lang</div><div class="dhow">hold CW/L6 (izq-ext)</div></div></div>
  <div class="kb">
    <div class="kb-row">
      <div class="kb-key kb-extra dim" id="l6-k-esc"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l6-k-q"><span class="kl">·</span></div><div class="kb-key dim" id="l6-k-w"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l6-k-f"><span class="kl">·</span></div><div class="kb-key dim" id="l6-k-p"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l6-k-b"><span class="kl">·</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key dim" id="l6-k-j"><span class="kl">·</span></div><div class="kb-key dim" id="l6-k-l"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l6-k-u"><span class="kl">·</span></div><div class="kb-key dim" id="l6-k-y"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l6-k-semi"><span class="kl">·</span></div><div class="kb-key kb-extra dim" id="l6-k-bspc"><span class="kl">·</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra dim" id="l6-k-tab"><span class="kl">·</span></div>
      <div class="kb-key active L6" id="l6-k-a"><span class="kl">´</span><span class="km">dead acute</span></div>
      <div class="kb-key active L6" id="l6-k-r"><span class="kl">~</span><span class="km">dead tilde</span></div>
      <div class="kb-key active L6" id="l6-k-s"><span class="kl">¨</span><span class="km">dead umlaut</span></div>
      <div class="kb-key active L6" id="l6-k-t"><span class="kl">¿</span></div>
      <div class="kb-key active L6" id="l6-k-g"><span class="kl">¡</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key dim" id="l6-k-m"><span class="kl">·</span></div><div class="kb-key dim" id="l6-k-n"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l6-k-e"><span class="kl">·</span></div><div class="kb-key dim" id="l6-k-i"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l6-k-o"><span class="kl">·</span></div><div class="kb-key dim" id="l6-k-apos"><span class="kl">·</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra dim" id="l6-k-ctrl"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l6-k-z"><span class="kl">·</span></div><div class="kb-key dim" id="l6-k-x"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l6-k-c"><span class="kl">·</span></div><div class="kb-key dim" id="l6-k-d"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l6-k-v"><span class="kl">·</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key dim" id="l6-k-k"><span class="kl">·</span></div><div class="kb-key dim" id="l6-k-h"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l6-k-comma"><span class="kl">·</span></div><div class="kb-key dim" id="l6-k-dot"><span class="kl">·</span></div>
      <div class="kb-key dim" id="l6-k-slash"><span class="kl">·</span></div><div class="kb-key kb-extra dim" id="l6-k-ret"><span class="kl">·</span></div>
    </div>
    <div class="kb-row kb-center">
      <div class="kb-key kb-thumb dim" id="l6-k-cpsw"><span class="kl">[hld]</span><span class="km">CW/L6</span></div>
      <div class="kb-key kb-thumb dim" id="l6-k-gui"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb dim" id="l6-k-mo7"><span class="kl">·</span></div>
      <div class="kb-sep" style="width:24px"></div>
      <div class="kb-key kb-thumb dim" id="l6-k-mo2"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb dim" id="l6-k-mo1"><span class="kl">·</span></div>
      <div class="kb-key kb-thumb dim" id="l6-k-sym5"><span class="kl">·</span></div>
    </div>
  </div>
  <ul class="notes">
    <li><b>´</b>: dead acute (⌥E) → á/é/í/ó/ú</li>
    <li><b>~</b>: dead tilde (⌥N) → ñ</li>
    <li><b>¨</b>: dead umlaut (⌥U) → ü</li>
    <li><b>¿</b> y <b>¡</b>: teclas directas</li>
  </ul>
</div>

<!-- LAYER 7 -->
<div id="v-7" class="view L7">
  <div class="dhdr L7"><div class="dnum L7">7</div><div><div class="dname">Apps</div><div class="dhow">hold MO7 (izq-med)</div></div></div>
  <div class="kb">
    <div class="kb-row">
      <div class="kb-key kb-extra dim" id="l7-k-esc"><span class="kl">·</span></div>
      <div class="kb-key active L7" id="l7-k-q"><span class="kl">WTAB</span><span class="km">⌘T</span></div>
      <div class="kb-key active L7" id="l7-k-w"><span class="kl">WCLS</span><span class="km">⌘W</span></div>
      <div class="kb-key active L7" id="l7-k-f"><span class="kl">WSPL-V</span><span class="km">⌘D</span></div>
      <div class="kb-key active L7" id="l7-k-p"><span class="kl">WSPL-H</span><span class="km">⌘⇧D</span></div>
      <div class="kb-key dim" id="l7-k-b"><span class="kl">·</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L7" id="l7-k-j"><span class="kl">WEZ</span><span class="km">⌥⌘⇧W</span></div>
      <div class="kb-key active L7" id="l7-k-l"><span class="kl">SLK</span><span class="km">⌥⌘⇧S</span></div>
      <div class="kb-key active L7" id="l7-k-u"><span class="kl">ZOM</span><span class="km">⌥⌘⇧Z</span></div>
      <div class="kb-key active L7" id="l7-k-y"><span class="kl">CHR</span><span class="km">⌥⌘⇧C</span></div>
      <div class="kb-key active L7" id="l7-k-semi"><span class="kl">CYCL</span><span class="km">⌘`</span></div>
      <div class="kb-key kb-extra inherited" id="l7-k-bspc"><span class="kl">⌫</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra dim" id="l7-k-tab"><span class="kl">·</span></div>
      <div class="kb-key active L7" id="l7-k-a"><span class="kl">ZMUT</span><span class="km">⌘⇧A</span></div>
      <div class="kb-key active L7" id="l7-k-r"><span class="kl">ZVID</span><span class="km">⌘⇧V</span></div>
      <div class="kb-key active L7" id="l7-k-s"><span class="kl">ZSHR</span><span class="km">⌘⇧S</span></div>
      <div class="kb-key active L7" id="l7-k-t"><span class="kl">ZLVE</span><span class="km">⌘⇧H</span></div>
      <div class="kb-key dim" id="l7-k-g"><span class="kl">·</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key active L7" id="l7-k-m"><span class="kl">HELP</span><span class="km">⌥⌘⇧H</span></div>
      <div class="kb-key inherited" id="l7-k-n"><span class="kl">←</span></div>
      <div class="kb-key inherited" id="l7-k-e"><span class="kl">↓</span></div>
      <div class="kb-key inherited" id="l7-k-i"><span class="kl">→</span></div>
      <div class="kb-key inherited" id="l7-k-o"><span class="kl">HOME</span></div>
      <div class="kb-key inherited" id="l7-k-apos"><span class="kl">PGUP</span></div>
    </div>
    <div class="kb-row">
      <div class="kb-key kb-extra dim" id="l7-k-ctrl"><span class="kl">·</span></div>
      <div class="kb-key active L7" id="l7-k-z"><span class="kl">CLNEW</span><span class="km">⌘N</span></div>
      <div class="kb-key active L7" id="l7-k-x"><span class="kl">SMEN</span><span class="km">⌘⇧M</span></div>
      <div class="kb-key active L7" id="l7-k-c"><span class="kl">SCOD</span><span class="km">⌘⇧C</span></div>
      <div class="kb-key active L7" id="l7-k-d"><span class="kl">SJMP</span><span class="km">⌘K</span></div>
      <div class="kb-key dim" id="l7-k-v"><span class="kl">·</span></div>
      <div class="kb-sep"></div>
      <div class="kb-key inherited" id="l7-k-k"><span class="kl">SEL↑</span></div>
      <div class="kb-key inherited" id="l7-k-h"><span class="kl">SEL←</span></div>
      <div class="kb-key inherited" id="l7-k-comma"><span class="kl">SEL↓</span></div>
      <div class="kb-key inherited" id="l7-k-dot"><span class="kl">SEL→</span></div>
      <div class="kb-key inherited" id="l7-k-slash"><span class="kl">END</span></div>
      <div class="kb-key kb-extra inherited" id="l7-k-ret"><span class="kl">PGDN</span></div>
    </div>
    <div class="kb-row kb-center">
      <div class="kb-key kb-thumb inherited" id="l7-k-cpsw"><span class="kl">CW/L6</span></div>
      <div class="kb-key kb-thumb dim" id="l7-k-gui"><span class="kl">[hld]</span><span class="km">Apps7</span></div>
      <div class="kb-key kb-thumb dim" id="l7-k-mo7"><span class="kl">·</span></div>
      <div class="kb-sep" style="width:24px"></div>
      <div class="kb-key kb-thumb inherited" id="l7-k-mo2"><span class="kl">RET/L5</span></div>
      <div class="kb-key kb-thumb inherited" id="l7-k-mo1"><span class="kl">MO2</span></div>
      <div class="kb-key kb-thumb inherited" id="l7-k-sym5"><span class="kl">MO1</span></div>
    </div>
  </div>
  <ul class="notes">
    <li>Activación: hold <b>MO7</b> (izq-med) — sin tap, ⌃ Ctrl vía HRM en S</li>
    <li>Der fila sup: focus-or-launch vía Hammerspoon (⌥⌘⇧W/S/Z/C)</li>
    <li><b>HELP</b> (tecla M): abre/cierra este popup</li>
    <li>Grises punteados: heredados de Layer 2 Nav (transparentes)</li>
  </ul>
</div>

</div><!-- .content -->
</div><!-- .main -->
</body>
</html>]]

local function toggleKeymapHelp()
    if keymapWebview then
        if keymapWebview:isVisible() then
            keymapWebview:hide()
            _prevLayer = "home"
        else
            _prevLayer = "home"
            keymapWebview:evaluateJavaScript('show("home")')
            keymapWebview:show()
            keymapWebview:bringToFront()
        end
        return
    end
    local screen = hs.screen.mainScreen():frame()
    local w, h = 1040, 560
    keymapWebview = hs.webview.new({
        x = screen.x + (screen.w - w) / 2,
        y = screen.y + 80,
        w = w, h = h,
    })
    keymapWebview:windowStyle({"utility", "HUD", "titled", "closable"})
    keymapWebview:level(hs.drawing.windowLevels.floating)
    keymapWebview:allowGestures(false)
    keymapWebview:allowNewWindows(false)
    keymapWebview:windowTitle("Keymap Reference")
    keymapWebview:html(keymapHtml)
    keymapWebview:show()
end

hs.hotkey.bind({"cmd","alt","shift"}, "H", toggleKeymapHelp)

-- Layer 0 (Base): keycode → physical key element ID
local kcToKeyL0 = {
    [53]="l0-k-esc",
    [12]="l0-k-q",  [13]="l0-k-w",  [3]="l0-k-f",   [35]="l0-k-p",  [11]="l0-k-b",
    [38]="l0-k-j",  [37]="l0-k-l",  [32]="l0-k-u",  [16]="l0-k-y",  [41]="l0-k-semi",
    [51]="l0-k-bspc", [48]="l0-k-tab",
    [0]="l0-k-a",   [15]="l0-k-r",  [1]="l0-k-s",   [17]="l0-k-t",  [5]="l0-k-g",
    [46]="l0-k-m",  [45]="l0-k-n",  [14]="l0-k-e",  [34]="l0-k-i",  [31]="l0-k-o",  [39]="l0-k-apos",
    [6]="l0-k-z",   [7]="l0-k-x",   [8]="l0-k-c",   [2]="l0-k-d",   [9]="l0-k-v",
    [40]="l0-k-k",  [4]="l0-k-h",   [43]="l0-k-comma", [47]="l0-k-dot", [44]="l0-k-slash",
    [36]="l0-k-mo2", -- kc=36 (RET) → thumb der-int (RET/L5)
}

-- Layer 6 (Lang): alt + specific key → español dead keys / ¿ / ¡
local function kcToKeyL6(kc)
    if     kc == 14 then return "l6-k-a"   -- ´ (⌥E)
    elseif kc == 45 then return "l6-k-r"   -- ~ (⌥N)
    elseif kc == 32 then return "l6-k-s"   -- ¨ (⌥U)
    elseif kc == 44 then return "l6-k-t"   -- ¿ (⌥⇧/)
    elseif kc == 18 then return "l6-k-g"   -- ¡ (⌥1)
    end
    return nil
end

-- Layer 1 (Sym): same keycode, shift flag disambiguates row-0 (number) vs row-1 (symbol)
local function kcToKeyL1(kc, flags)
    local s = flags.shift
    if     kc == 18  then return s and "l1-k-a"     or "l1-k-q"    -- 1/!
    elseif kc == 19  then return s and "l1-k-r"     or "l1-k-w"    -- 2/@
    elseif kc == 20  then return s and "l1-k-s"     or "l1-k-f"    -- 3/#
    elseif kc == 21  then return s and "l1-k-t"     or "l1-k-p"    -- 4/$
    elseif kc == 23  then return s and "l1-k-g"     or "l1-k-b"    -- 5/%
    elseif kc == 22  then return s and "l1-k-e"     or "l1-k-j"    -- 6/^
    elseif kc == 26  then return s and "l1-k-z"     or "l1-k-l"    -- 7/&
    elseif kc == 28  then return s and "l1-k-x"     or "l1-k-u"    -- 8/*
    elseif kc == 25  then return s and "l1-k-c"     or "l1-k-y"    -- 9/(
    elseif kc == 29  then return s and "l1-k-d"     or "l1-k-semi" -- 0/)
    elseif kc == 27  then return s and "l1-k-v"     or "l1-k-m"    -- -/_
    elseif kc == 24  then return s and "l1-k-slash" or "l1-k-n"    -- =/+
    elseif kc == 42  then return s and "l1-k-i"     or "l1-k-o"    -- \|
    elseif kc == 33  then return s and "l1-k-comma" or "l1-k-k"    -- [{
    elseif kc == 30  then return s and "l1-k-dot"   or "l1-k-h"    -- ]}
    elseif kc == 50  then return "l1-k-apos"   -- `
    elseif kc == 117 then return "l1-k-bspc"   -- DEL fwd
    elseif kc == 48  then return "l1-k-tab"
    elseif kc == 36  then return "l1-k-ret"
    end
    return nil
end

-- Layer 2 (Nav): keycode + modifiers → physical key element ID
local function kcToKeyL2(kc, flags)
    if kc == 123 then       -- Left arrow
        if flags.alt   then return "l2-k-l"      end  -- WJ← (⌥←)
        if flags.shift then return "l2-k-h"      end  -- SEL←
        return "l2-k-n"                                -- ←
    elseif kc == 124 then   -- Right arrow
        if flags.alt   then return "l2-k-y"      end  -- WJ→ (⌥→)
        if flags.shift then return "l2-k-dot"    end  -- SEL→
        return "l2-k-i"                                -- →
    elseif kc == 125 then   -- Down arrow
        if flags.shift then return "l2-k-comma"  end  -- SEL↓
        return "l2-k-e"                                -- ↓
    elseif kc == 126 then   -- Up arrow
        if flags.shift then return "l2-k-k"     end   -- SEL↑
        return "l2-k-u"                                -- ↑
    elseif kc == 115 then   -- Home
        if flags.shift then return "l2-k-j"     end   -- ⇧HOME
        return "l2-k-o"                                -- HOME
    elseif kc == 119 then   -- End
        if flags.shift then return "l2-k-semi"  end   -- ⇧END
        return "l2-k-slash"                            -- END
    elseif kc == 116 then return "l2-k-apos"           -- PGUP
    elseif kc == 121 then return "l2-k-ret"            -- PGDN
    elseif kc == 51  then return "l2-k-bspc"           -- BSPC
    end
    return nil
end

-- Layer 4 (Fn): F1-F12 → physical key element ID
local kcToKeyL4 = {
    [122]="l4-k-esc", [120]="l4-k-q",  [99]="l4-k-w",   [118]="l4-k-f",
    [96]="l4-k-p",    [97]="l4-k-b",   [98]="l4-k-j",   [100]="l4-k-l",
    [101]="l4-k-u",   [109]="l4-k-y",  [103]="l4-k-semi",[111]="l4-k-bspc",
}

-- Layer 7 (Apps): ⌥⌘⇧+letter received keycode → physical key element ID
local kcToKeyL7 = {
    [13]="l7-k-j",   -- ⌥⌘⇧W → J (WEZ)
    [1]="l7-k-l",    -- ⌥⌘⇧S → L (SLK)
    [6]="l7-k-u",    -- ⌥⌘⇧Z → U (ZOM)
    [8]="l7-k-y",    -- ⌥⌘⇧C → Y (CHR)
}

-- Infer which ZMK layer generated the keycode received by macOS
local function inferLayer(kc, flags)
    if flags.cmd and flags.alt and flags.shift then return "7" end
    -- Lang (6): ⌥ + dead-key codes — checked before symKC because ⌥1 (¡) shares kc=18 with !
    if flags.alt then
        local langKC = {[14]=1,[45]=1,[32]=1,[44]=1,[18]=1}
        if langKC[kc] then return "6" end
    end
    local fnKC  = {[122]=1,[120]=1,[99]=1,[118]=1,[96]=1,[97]=1,[98]=1,[100]=1,[101]=1,[109]=1,[103]=1,[111]=1}
    if fnKC[kc]  then return "4" end
    local navKC = {[123]=1,[124]=1,[125]=1,[126]=1,[115]=1,[119]=1,[116]=1,[121]=1}
    if navKC[kc] then return "2" end
    local symKC = {[18]=1,[19]=1,[20]=1,[21]=1,[22]=1,[23]=1,[25]=1,[26]=1,[28]=1,[29]=1,
                   [27]=1,[24]=1,[33]=1,[30]=1,[42]=1,[50]=1,[117]=1}
    if symKC[kc] then return "1" end
    return "0"
end

local function getKeyId(layer, kc, flags)
    if     layer == "0" then return kcToKeyL0[kc]
    elseif layer == "1" then return kcToKeyL1(kc, flags)
    elseif layer == "2" then return kcToKeyL2(kc, flags)
    elseif layer == "4" then return kcToKeyL4[kc]
    elseif layer == "6" then return kcToKeyL6(kc)
    elseif layer == "7" then return kcToKeyL7[kc]
    end
    return nil
end

_keyWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    if not (keymapWebview and keymapWebview:isVisible()) then return false end
    local kc    = event:getKeyCode()
    local flags = event:getFlags()
    local layer = inferLayer(kc, flags)
    local kid   = getKeyId(layer, kc, flags)

    if layer ~= _prevLayer then
        _prevLayer = layer
        -- Combine show + pressKey in one JS call to avoid race condition
        local js = 'show("' .. layer .. '")'
        if kid then
            js = js .. '; setTimeout(function(){ pressKey("' .. kid .. '") }, 150)'
        end
        keymapWebview:evaluateJavaScript(js)
    elseif kid then
        keymapWebview:evaluateJavaScript('pressKey("' .. kid .. '")')
    end
    return false
end)
_keyWatcher:start()
