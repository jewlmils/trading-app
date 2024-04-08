const e =
  typeof navigator !== "undefined" &&
  navigator.userAgent.toLowerCase().indexOf("firefox") > 0;
function addEvent(e, t, n, o) {
  e.addEventListener
    ? e.addEventListener(t, n, o)
    : e.attachEvent && e.attachEvent("on".concat(t), n);
}
function removeEvent(e, t, n, o) {
  e.removeEventListener
    ? e.removeEventListener(t, n, o)
    : e.detachEvent && e.detachEvent("on".concat(t), n);
}
function getMods(e, t) {
  const n = t.slice(0, t.length - 1);
  for (let t = 0; t < n.length; t++) n[t] = e[n[t].toLowerCase()];
  return n;
}
function getKeys(e) {
  typeof e !== "string" && (e = "");
  e = e.replace(/\s/g, "");
  const t = e.split(",");
  let n = t.lastIndexOf("");
  for (; n >= 0; ) {
    t[n - 1] += ",";
    t.splice(n, 1);
    n = t.lastIndexOf("");
  }
  return t;
}
function compareArray(e, t) {
  const n = e.length >= t.length ? e : t;
  const o = e.length >= t.length ? t : e;
  let s = true;
  for (let e = 0; e < n.length; e++) o.indexOf(n[e]) === -1 && (s = false);
  return s;
}
const t = {
  backspace: 8,
  "⌫": 8,
  tab: 9,
  clear: 12,
  enter: 13,
  "↩": 13,
  return: 13,
  esc: 27,
  escape: 27,
  space: 32,
  left: 37,
  up: 38,
  right: 39,
  down: 40,
  del: 46,
  delete: 46,
  ins: 45,
  insert: 45,
  home: 36,
  end: 35,
  pageup: 33,
  pagedown: 34,
  capslock: 20,
  num_0: 96,
  num_1: 97,
  num_2: 98,
  num_3: 99,
  num_4: 100,
  num_5: 101,
  num_6: 102,
  num_7: 103,
  num_8: 104,
  num_9: 105,
  num_multiply: 106,
  num_add: 107,
  num_enter: 108,
  num_subtract: 109,
  num_decimal: 110,
  num_divide: 111,
  "⇪": 20,
  ",": 188,
  ".": 190,
  "/": 191,
  "`": 192,
  "-": e ? 173 : 189,
  "=": e ? 61 : 187,
  ";": e ? 59 : 186,
  "'": 222,
  "[": 219,
  "]": 221,
  "\\": 220,
};
const n = {
  "⇧": 16,
  shift: 16,
  "⌥": 18,
  alt: 18,
  option: 18,
  "⌃": 17,
  ctrl: 17,
  control: 17,
  "⌘": 91,
  cmd: 91,
  command: 91,
};
const o = {
  16: "shiftKey",
  18: "altKey",
  17: "ctrlKey",
  91: "metaKey",
  shiftKey: 16,
  ctrlKey: 17,
  altKey: 18,
  metaKey: 91,
};
const s = { 16: false, 18: false, 17: false, 91: false };
const r = {};
for (let e = 1; e < 20; e++) t["f".concat(e)] = 111 + e;
let c = [];
let i = null;
let l = "all";
const f = new Map();
const code = (e) =>
  t[e.toLowerCase()] || n[e.toLowerCase()] || e.toUpperCase().charCodeAt(0);
const getKey = (e) => Object.keys(t).find((n) => t[n] === e);
const getModifier = (e) => Object.keys(n).find((t) => n[t] === e);
function setScope(e) {
  l = e || "all";
}
function getScope() {
  return l || "all";
}
function getPressedKeyCodes() {
  return c.slice(0);
}
function getPressedKeyString() {
  return c.map((e) => getKey(e) || getModifier(e) || String.fromCharCode(e));
}
function getAllKeyCodes() {
  const e = [];
  Object.keys(r).forEach((t) => {
    r[t].forEach((t) => {
      let { key: n, scope: o, mods: s, shortcut: r } = t;
      e.push({
        scope: o,
        shortcut: r,
        mods: s,
        keys: n.split("+").map((e) => code(e)),
      });
    });
  });
  return e;
}
function filter(e) {
  const t = e.target || e.srcElement;
  const { tagName: n } = t;
  let o = true;
  const s =
    n === "INPUT" &&
    ![
      "checkbox",
      "radio",
      "range",
      "button",
      "file",
      "reset",
      "submit",
      "color",
    ].includes(t.type);
  (t.isContentEditable ||
    ((s || n === "TEXTAREA" || n === "SELECT") && !t.readOnly)) &&
    (o = false);
  return o;
}
function isPressed(e) {
  typeof e === "string" && (e = code(e));
  return c.indexOf(e) !== -1;
}
function deleteScope(e, t) {
  let n;
  let o;
  e || (e = getScope());
  for (const t in r)
    if (Object.prototype.hasOwnProperty.call(r, t)) {
      n = r[t];
      for (o = 0; o < n.length; )
        if (n[o].scope === e) {
          const e = n.splice(o, 1);
          e.forEach((e) => {
            let { element: t } = e;
            return removeKeyEvent(t);
          });
        } else o++;
    }
  getScope() === e && setScope(t || "all");
}
function clearModifier(e) {
  let t = e.keyCode || e.which || e.charCode;
  const o = c.indexOf(t);
  o >= 0 && c.splice(o, 1);
  e.key && e.key.toLowerCase() === "meta" && c.splice(0, c.length);
  (t !== 93 && t !== 224) || (t = 91);
  if (t in s) {
    s[t] = false;
    for (const e in n) n[e] === t && (hotkeys[e] = false);
  }
}
function unbind(e) {
  if (typeof e === "undefined") {
    Object.keys(r).forEach((e) => {
      Array.isArray(r[e]) && r[e].forEach((e) => eachUnbind(e));
      delete r[e];
    });
    removeKeyEvent(null);
  } else if (Array.isArray(e))
    e.forEach((e) => {
      e.key && eachUnbind(e);
    });
  else if (typeof e === "object") e.key && eachUnbind(e);
  else if (typeof e === "string") {
    for (
      var t = arguments.length, n = new Array(t > 1 ? t - 1 : 0), o = 1;
      o < t;
      o++
    )
      n[o - 1] = arguments[o];
    let [s, r] = n;
    if (typeof s === "function") {
      r = s;
      s = "";
    }
    eachUnbind({ key: e, scope: s, method: r, splitKey: "+" });
  }
}
const eachUnbind = (e) => {
  let { key: t, scope: o, method: s, splitKey: c = "+" } = e;
  const i = getKeys(t);
  i.forEach((e) => {
    const t = e.split(c);
    const i = t.length;
    const l = t[i - 1];
    const f = l === "*" ? "*" : code(l);
    if (!r[f]) return;
    o || (o = getScope());
    const a = i > 1 ? getMods(n, t) : [];
    const d = [];
    r[f] = r[f].filter((e) => {
      const t = !s || e.method === s;
      const n = t && e.scope === o && compareArray(e.mods, a);
      n && d.push(e.element);
      return !n;
    });
    d.forEach((e) => removeKeyEvent(e));
  });
};
function eventHandler(e, t, n, o) {
  if (t.element !== o) return;
  let r;
  if (t.scope === n || t.scope === "all") {
    r = t.mods.length > 0;
    for (const e in s)
      Object.prototype.hasOwnProperty.call(s, e) &&
        ((!s[e] && t.mods.indexOf(+e) > -1) ||
          (s[e] && t.mods.indexOf(+e) === -1)) &&
        (r = false);
    if (
      (t.mods.length === 0 && !s[16] && !s[18] && !s[17] && !s[91]) ||
      r ||
      t.shortcut === "*"
    ) {
      t.keys = [];
      t.keys = t.keys.concat(c);
      if (t.method(e, t) === false) {
        e.preventDefault ? e.preventDefault() : (e.returnValue = false);
        e.stopPropagation && e.stopPropagation();
        e.cancelBubble && (e.cancelBubble = true);
      }
    }
  }
}
function dispatch(e, t) {
  const i = r["*"];
  let l = e.keyCode || e.which || e.charCode;
  if (!hotkeys.filter.call(this, e)) return;
  (l !== 93 && l !== 224) || (l = 91);
  c.indexOf(l) === -1 && l !== 229 && c.push(l);
  ["ctrlKey", "altKey", "shiftKey", "metaKey"].forEach((t) => {
    const n = o[t];
    e[t] && c.indexOf(n) === -1
      ? c.push(n)
      : !e[t] && c.indexOf(n) > -1
      ? c.splice(c.indexOf(n), 1)
      : t === "metaKey" &&
        e[t] &&
        c.length === 3 &&
        (e.ctrlKey || e.shiftKey || e.altKey || (c = c.slice(c.indexOf(n))));
  });
  if (l in s) {
    s[l] = true;
    for (const e in n) n[e] === l && (hotkeys[e] = true);
    if (!i) return;
  }
  for (const t in s)
    Object.prototype.hasOwnProperty.call(s, t) && (s[t] = e[o[t]]);
  if (
    e.getModifierState &&
    !(e.altKey && !e.ctrlKey) &&
    e.getModifierState("AltGraph")
  ) {
    c.indexOf(17) === -1 && c.push(17);
    c.indexOf(18) === -1 && c.push(18);
    s[17] = true;
    s[18] = true;
  }
  const f = getScope();
  if (i)
    for (let n = 0; n < i.length; n++)
      i[n].scope === f &&
        ((e.type === "keydown" && i[n].keydown) ||
          (e.type === "keyup" && i[n].keyup)) &&
        eventHandler(e, i[n], f, t);
  if (!(l in r)) return;
  const a = r[l];
  const d = a.length;
  for (let n = 0; n < d; n++)
    if (
      ((e.type === "keydown" && a[n].keydown) ||
        (e.type === "keyup" && a[n].keyup)) &&
      a[n].key
    ) {
      const o = a[n];
      const { splitKey: s } = o;
      const r = o.key.split(s);
      const i = [];
      for (let e = 0; e < r.length; e++) i.push(code(r[e]));
      i.sort().join("") === c.sort().join("") && eventHandler(e, o, f, t);
    }
}
function hotkeys(e, t, o) {
  c = [];
  const s = getKeys(e);
  let l = [];
  let a = "all";
  let d = document;
  let y = 0;
  let p = false;
  let u = true;
  let h = "+";
  let g = false;
  let m = false;
  o === void 0 && typeof t === "function" && (o = t);
  if (Object.prototype.toString.call(t) === "[object Object]") {
    t.scope && (a = t.scope);
    t.element && (d = t.element);
    t.keyup && (p = t.keyup);
    t.keydown !== void 0 && (u = t.keydown);
    t.capture !== void 0 && (g = t.capture);
    typeof t.splitKey === "string" && (h = t.splitKey);
    t.single === true && (m = true);
  }
  typeof t === "string" && (a = t);
  m && unbind(e, a);
  for (; y < s.length; y++) {
    e = s[y].split(h);
    l = [];
    e.length > 1 && (l = getMods(n, e));
    e = e[e.length - 1];
    e = e === "*" ? "*" : code(e);
    e in r || (r[e] = []);
    r[e].push({
      keyup: p,
      keydown: u,
      scope: a,
      mods: l,
      shortcut: s[y],
      method: o,
      key: s[y],
      splitKey: h,
      element: d,
    });
  }
  if (typeof d !== "undefined" && window) {
    if (!f.has(d)) {
      const keydownListener = function () {
        let e =
          arguments.length > 0 && arguments[0] !== void 0
            ? arguments[0]
            : window.event;
        return dispatch(e, d);
      };
      const keyupListenr = function () {
        let e =
          arguments.length > 0 && arguments[0] !== void 0
            ? arguments[0]
            : window.event;
        dispatch(e, d);
        clearModifier(e);
      };
      f.set(d, {
        keydownListener: keydownListener,
        keyupListenr: keyupListenr,
        capture: g,
      });
      addEvent(d, "keydown", keydownListener, g);
      addEvent(d, "keyup", keyupListenr, g);
    }
    if (!i) {
      const listener = () => {
        c = [];
      };
      i = { listener: listener, capture: g };
      addEvent(window, "focus", listener, g);
    }
  }
}
function trigger(e) {
  let t =
    arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : "all";
  Object.keys(r).forEach((n) => {
    const o = r[n].filter((n) => n.scope === t && n.shortcut === e);
    o.forEach((e) => {
      e && e.method && e.method();
    });
  });
}
function removeKeyEvent(e) {
  const t = Object.values(r).flat();
  const n = t.findIndex((t) => {
    let { element: n } = t;
    return n === e;
  });
  if (n < 0) {
    const { keydownListener: t, keyupListenr: n, capture: o } = f.get(e) || {};
    if (t && n) {
      removeEvent(e, "keyup", n, o);
      removeEvent(e, "keydown", t, o);
      f.delete(e);
    }
  }
  if (t.length <= 0 || f.size <= 0) {
    const e = Object.keys(f);
    e.forEach((e) => {
      const {
        keydownListener: t,
        keyupListenr: n,
        capture: o,
      } = f.get(e) || {};
      if (t && n) {
        removeEvent(e, "keyup", n, o);
        removeEvent(e, "keydown", t, o);
        f.delete(e);
      }
    });
    f.clear();
    Object.keys(r).forEach((e) => delete r[e]);
    if (i) {
      const { listener: e, capture: t } = i;
      removeEvent(window, "focus", e, t);
      i = null;
    }
  }
}
const a = {
  getPressedKeyString: getPressedKeyString,
  setScope: setScope,
  getScope: getScope,
  deleteScope: deleteScope,
  getPressedKeyCodes: getPressedKeyCodes,
  getAllKeyCodes: getAllKeyCodes,
  isPressed: isPressed,
  filter: filter,
  trigger: trigger,
  unbind: unbind,
  keyMap: t,
  modifier: n,
  modifierMap: o,
};
for (const e in a)
  Object.prototype.hasOwnProperty.call(a, e) && (hotkeys[e] = a[e]);
if (typeof window !== "undefined") {
  const e = window.hotkeys;
  hotkeys.noConflict = (t) => {
    t && window.hotkeys === hotkeys && (window.hotkeys = e);
    return hotkeys;
  };
  window.hotkeys = hotkeys;
}
export { hotkeys as default };
