import { Controller as e } from "@hotwired/stimulus";
import t from "hotkeys-js";
const method = (e, t) => {
  const s = e[t];
  return "function" == typeof s ? s : (...e) => {};
};
const composeEventName = (e, t, s) => {
  let n = e;
  true === s
    ? (n = `${t.identifier}:${e}`)
    : "string" === typeof s && (n = `${s}:${e}`);
  return n;
};
const extendedEvent = (e, t, s) => {
  const {
    bubbles: n,
    cancelable: o,
    composed: i,
  } = t || { bubbles: true, cancelable: true, composed: true };
  t && Object.assign(s, { originalEvent: t });
  const r = new CustomEvent(e, {
    bubbles: n,
    cancelable: o,
    composed: i,
    detail: s,
  });
  return r;
};
function isElementInViewport(e) {
  const t = e.getBoundingClientRect();
  const s = window.innerHeight || document.documentElement.clientHeight;
  const n = window.innerWidth || document.documentElement.clientWidth;
  const o = t.top <= s && t.top + t.height > 0;
  const i = t.left <= n && t.left + t.width > 0;
  return o && i;
}
function camelize(e) {
  return e.replace(/(?:[_-])([a-z0-9])/g, (e, t) => t.toUpperCase());
}
const s = {
  dispatchEvent: true,
  eventPrefix: true,
  visibleAttribute: "isVisible",
};
const useIntersection = (e, t = {}) => {
  const n = e;
  const {
    dispatchEvent: o,
    eventPrefix: i,
    visibleAttribute: r,
  } = Object.assign({}, s, t);
  const l = (null === t || void 0 === t ? void 0 : t.element) || n.element;
  n.intersectionElements || (n.intersectionElements = []);
  n.intersectionElements.push(l);
  const callback = (e) => {
    const [t] = e;
    t.isIntersecting
      ? dispatchAppear(t)
      : l.hasAttribute(r) && dispatchDisappear(t);
  };
  const dispatchAppear = (e) => {
    l.setAttribute(r, "true");
    method(n, "appear").call(n, e);
    if (o) {
      const t = composeEventName("appear", n, i);
      const s = extendedEvent(t, null, { controller: n, entry: e });
      l.dispatchEvent(s);
    }
  };
  const dispatchDisappear = (e) => {
    l.removeAttribute(r);
    method(n, "disappear").call(n, e);
    if (o) {
      const t = composeEventName("disappear", n, i);
      const s = extendedEvent(t, null, { controller: n, entry: e });
      l.dispatchEvent(s);
    }
  };
  const c = n.disconnect.bind(n);
  const a = new IntersectionObserver(callback, t);
  const observe = () => {
    a.observe(l);
  };
  const unobserve = () => {
    a.unobserve(l);
  };
  const noneVisible = () =>
    0 === n.intersectionElements.filter((e) => e.hasAttribute(r)).length;
  const oneVisible = () =>
    1 === n.intersectionElements.filter((e) => e.hasAttribute(r)).length;
  const atLeastOneVisible = () =>
    n.intersectionElements.some((e) => e.hasAttribute(r));
  const allVisible = () =>
    n.intersectionElements.every((e) => e.hasAttribute(r));
  const h = allVisible;
  Object.assign(n, {
    isVisible: h,
    noneVisible: noneVisible,
    oneVisible: oneVisible,
    atLeastOneVisible: atLeastOneVisible,
    allVisible: allVisible,
    disconnect() {
      unobserve();
      c();
    },
  });
  observe();
  return [observe, unobserve];
};
class IntersectionComposableController extends e {}
class IntersectionController extends IntersectionComposableController {
  constructor(e) {
    super(e);
    requestAnimationFrame(() => {
      const [e, t] = useIntersection(this, this.options);
      Object.assign(this, { observe: e, unobserve: t });
    });
  }
}
const useLazyLoad = (e, t) => {
  const callback = (t) => {
    const [s] = t;
    s.isIntersecting && !e.isLoaded && handleAppear();
  };
  const handleAppear = (t) => {
    const s = e.data.get("src");
    if (!s) return;
    const n = e.element;
    e.isLoading = true;
    method(e, "loading").call(e, s);
    n.onload = () => {
      handleLoaded(s);
    };
    n.src = s;
  };
  const handleLoaded = (t) => {
    e.isLoading = false;
    e.isLoaded = true;
    method(e, "loaded").call(e, t);
  };
  const s = e.disconnect.bind(e);
  const n = new IntersectionObserver(callback, t);
  const observe = () => {
    n.observe(e.element);
  };
  const unobserve = () => {
    n.unobserve(e.element);
  };
  Object.assign(e, {
    isVisible: false,
    disconnect() {
      unobserve();
      s();
    },
  });
  observe();
  return [observe, unobserve];
};
class LazyLoadComposableController extends e {
  constructor() {
    super(...arguments);
    this.isLoading = false;
    this.isLoaded = false;
  }
}
class LazyLoadController extends LazyLoadComposableController {
  constructor(e) {
    super(e);
    this.options = { rootMargin: "10%" };
    requestAnimationFrame(() => {
      const [e, t] = useLazyLoad(this, this.options);
      Object.assign(this, { observe: e, unobserve: t });
    });
  }
}
const n = { dispatchEvent: true, eventPrefix: true };
const useResize = (e, t = {}) => {
  const s = e;
  const { dispatchEvent: o, eventPrefix: i } = Object.assign({}, n, t);
  const r = (null === t || void 0 === t ? void 0 : t.element) || s.element;
  const callback = (e) => {
    const [t] = e;
    method(s, "resize").call(s, t.contentRect);
    if (o) {
      const e = composeEventName("resize", s, i);
      const n = extendedEvent(e, null, { controller: s, entry: t });
      r.dispatchEvent(n);
    }
  };
  const l = s.disconnect.bind(s);
  const c = new ResizeObserver(callback);
  const observe = () => {
    c.observe(r);
  };
  const unobserve = () => {
    c.unobserve(r);
  };
  Object.assign(s, {
    disconnect() {
      unobserve();
      l();
    },
  });
  observe();
  return [observe, unobserve];
};
class ResizeComposableController extends e {}
class ResizeController extends ResizeComposableController {
  constructor(e) {
    super(e);
    requestAnimationFrame(() => {
      const [e, t] = useResize(this, this.options);
      Object.assign(this, { observe: e, unobserve: t });
    });
  }
}
const o = {
  events: ["click", "touchend"],
  onlyVisible: true,
  dispatchEvent: true,
  eventPrefix: true,
};
const useClickOutside = (e, t = {}) => {
  const s = e;
  const {
    onlyVisible: n,
    dispatchEvent: i,
    events: r,
    eventPrefix: l,
  } = Object.assign({}, o, t);
  const onEvent = (e) => {
    const o = (null === t || void 0 === t ? void 0 : t.element) || s.element;
    if (!(o.contains(e.target) || (!isElementInViewport(o) && n))) {
      s.clickOutside && s.clickOutside(e);
      if (i) {
        const t = composeEventName("click:outside", s, l);
        const n = extendedEvent(t, e, { controller: s });
        o.dispatchEvent(n);
      }
    }
  };
  const observe = () => {
    null === r || void 0 === r
      ? void 0
      : r.forEach((e) => {
          window.addEventListener(e, onEvent, false);
        });
  };
  const unobserve = () => {
    null === r || void 0 === r
      ? void 0
      : r.forEach((e) => {
          window.removeEventListener(e, onEvent, false);
        });
  };
  const c = s.disconnect.bind(s);
  Object.assign(s, {
    disconnect() {
      unobserve();
      c();
    },
  });
  observe();
  return [observe, unobserve];
};
class ClickOutsideComposableController extends e {}
class ClickOutsideController extends ClickOutsideComposableController {
  constructor(e) {
    super(e);
    requestAnimationFrame(() => {
      const [e, t] = useClickOutside(this, this.options);
      Object.assign(this, { observe: e, unobserve: t });
    });
  }
}
function __rest(e, t) {
  var s = {};
  for (var n in e)
    Object.prototype.hasOwnProperty.call(e, n) &&
      t.indexOf(n) < 0 &&
      (s[n] = e[n]);
  if (null != e && "function" === typeof Object.getOwnPropertySymbols) {
    var o = 0;
    for (n = Object.getOwnPropertySymbols(e); o < n.length; o++)
      t.indexOf(n[o]) < 0 &&
        Object.prototype.propertyIsEnumerable.call(e, n[o]) &&
        (s[n[o]] = e[n[o]]);
  }
  return s;
}
const i = {
  debug: false,
  logger: console,
  dispatchEvent: true,
  eventPrefix: true,
};
class StimulusUse {
  constructor(e, t = {}) {
    var s, n, o;
    this.log = (e, t) => {
      if (this.debug) {
        this.logger.groupCollapsed(
          `%c${this.controller.identifier} %c#${e}`,
          "color: #3B82F6",
          "color: unset"
        );
        this.logger.log(Object.assign({ controllerId: this.controllerId }, t));
        this.logger.groupEnd();
      }
    };
    this.warn = (e) => {
      this.logger.warn(
        `%c${this.controller.identifier} %c${e}`,
        "color: #3B82F6; font-weight: bold",
        "color: unset"
      );
    };
    this.dispatch = (e, t = {}) => {
      if (this.dispatchEvent) {
        const { event: s } = t,
          n = __rest(t, ["event"]);
        const o = this.extendedEvent(e, s || null, n);
        this.targetElement.dispatchEvent(o);
        this.log("dispatchEvent", Object.assign({ eventName: o.type }, n));
      }
    };
    this.call = (e, t = {}) => {
      const s = this.controller[e];
      if ("function" == typeof s) return s.call(this.controller, t);
    };
    this.extendedEvent = (e, t, s) => {
      const {
        bubbles: n,
        cancelable: o,
        composed: i,
      } = t || { bubbles: true, cancelable: true, composed: true };
      t && Object.assign(s, { originalEvent: t });
      const r = new CustomEvent(this.composeEventName(e), {
        bubbles: n,
        cancelable: o,
        composed: i,
        detail: s,
      });
      return r;
    };
    this.composeEventName = (e) => {
      let t = e;
      true === this.eventPrefix
        ? (t = `${this.controller.identifier}:${e}`)
        : "string" === typeof this.eventPrefix &&
          (t = `${this.eventPrefix}:${e}`);
      return t;
    };
    this.debug =
      null !==
        (n =
          null !== (s = null === t || void 0 === t ? void 0 : t.debug) &&
          void 0 !== s
            ? s
            : e.application.stimulusUseDebug) && void 0 !== n
        ? n
        : i.debug;
    this.logger =
      null !== (o = null === t || void 0 === t ? void 0 : t.logger) &&
      void 0 !== o
        ? o
        : i.logger;
    this.controller = e;
    this.controllerId = e.element.id || e.element.dataset.id;
    this.targetElement =
      (null === t || void 0 === t ? void 0 : t.element) || e.element;
    const { dispatchEvent: r, eventPrefix: l } = Object.assign({}, i, t);
    Object.assign(this, { dispatchEvent: r, eventPrefix: l });
    this.controllerInitialize = e.initialize.bind(e);
    this.controllerConnect = e.connect.bind(e);
    this.controllerDisconnect = e.disconnect.bind(e);
  }
}
const r = { eventPrefix: true, bubbles: true, cancelable: true };
class UseDispatch extends StimulusUse {
  constructor(e, t = {}) {
    var s, n, o, i;
    super(e, t);
    this.dispatch = (e, t = {}) => {
      const {
        controller: s,
        targetElement: n,
        eventPrefix: o,
        bubbles: i,
        cancelable: r,
        log: l,
        warn: c,
      } = this;
      Object.assign(t, { controller: s });
      const a = composeEventName(e, this.controller, o);
      const h = new CustomEvent(a, { detail: t, bubbles: i, cancelable: r });
      n.dispatchEvent(h);
      c(
        "`useDispatch()` is deprecated. Please use the built-in `this.dispatch()` function from Stimulus. You can find more information on how to upgrade at: https://stimulus-use.github.io/stimulus-use/#/use-dispatch"
      );
      l("dispatch", { eventName: a, detail: t, bubbles: i, cancelable: r });
      return h;
    };
    this.targetElement =
      null !== (s = t.element) && void 0 !== s ? s : e.element;
    this.eventPrefix =
      null !== (n = t.eventPrefix) && void 0 !== n ? n : r.eventPrefix;
    this.bubbles = null !== (o = t.bubbles) && void 0 !== o ? o : r.bubbles;
    this.cancelable =
      null !== (i = t.cancelable) && void 0 !== i ? i : r.cancelable;
    this.enhanceController();
  }
  enhanceController() {
    Object.assign(this.controller, { dispatch: this.dispatch });
  }
}
const useDispatch = (e, t = {}) => new UseDispatch(e, t);
const l = { overwriteDispatch: true };
const useApplication = (e, t = {}) => {
  const { overwriteDispatch: s } = Object.assign({}, l, t);
  Object.defineProperty(e, "isPreview", {
    get() {
      return (
        document.documentElement.hasAttribute("data-turbolinks-preview") ||
        document.documentElement.hasAttribute("data-turbo-preview")
      );
    },
  });
  Object.defineProperty(e, "isConnected", {
    get() {
      return !!Array.from(this.context.module.connectedContexts).find(
        (e) => e === this.context
      );
    },
  });
  Object.defineProperty(e, "csrfToken", {
    get() {
      return this.metaValue("csrf-token");
    },
  });
  s && useDispatch(e, t);
  Object.assign(e, {
    metaValue(e) {
      const t = document.head.querySelector(`meta[name="${e}"]`);
      return t && t.getAttribute("content");
    },
  });
};
class ApplicationController extends e {
  constructor(e) {
    super(e);
    this.isPreview = false;
    this.isConnected = false;
    this.csrfToken = "";
    useApplication(this, this.options);
  }
}
const c = [
  "mousemove",
  "mousedown",
  "resize",
  "keydown",
  "touchstart",
  "wheel",
];
const a = 6e4;
const h = {
  ms: a,
  initialState: false,
  events: c,
  dispatchEvent: true,
  eventPrefix: true,
};
const useIdle = (e, t = {}) => {
  const s = e;
  const {
    ms: n,
    initialState: o,
    events: i,
    dispatchEvent: r,
    eventPrefix: l,
  } = Object.assign({}, h, t);
  let c = o;
  let a = setTimeout(() => {
    c = true;
    dispatchAway();
  }, n);
  const dispatchAway = (e) => {
    const t = composeEventName("away", s, l);
    s.isIdle = true;
    method(s, "away").call(s, e);
    if (r) {
      const n = extendedEvent(t, e || null, { controller: s });
      s.element.dispatchEvent(n);
    }
  };
  const dispatchBack = (e) => {
    const t = composeEventName("back", s, l);
    s.isIdle = false;
    method(s, "back").call(s, e);
    if (r) {
      const n = extendedEvent(t, e || null, { controller: s });
      s.element.dispatchEvent(n);
    }
  };
  const onEvent = (e) => {
    c && dispatchBack(e);
    c = false;
    clearTimeout(a);
    a = setTimeout(() => {
      c = true;
      dispatchAway(e);
    }, n);
  };
  const onVisibility = (e) => {
    document.hidden || onEvent(e);
  };
  c ? dispatchAway() : dispatchBack();
  const u = s.disconnect.bind(s);
  const observe = () => {
    i.forEach((e) => {
      window.addEventListener(e, onEvent);
    });
    document.addEventListener("visibilitychange", onVisibility);
  };
  const unobserve = () => {
    clearTimeout(a);
    i.forEach((e) => {
      window.removeEventListener(e, onEvent);
    });
    document.removeEventListener("visibilitychange", onVisibility);
  };
  Object.assign(s, {
    disconnect() {
      unobserve();
      u();
    },
  });
  observe();
  return [observe, unobserve];
};
class IdleComposableController extends e {
  constructor() {
    super(...arguments);
    this.isIdle = false;
  }
}
class IdleController extends IdleComposableController {
  constructor(e) {
    super(e);
    requestAnimationFrame(() => {
      const [e, t] = useIdle(this, this.options);
      Object.assign(this, { observe: e, unobserve: t });
    });
  }
}
class UseVisibility extends StimulusUse {
  constructor(e, t = {}) {
    super(e, t);
    this.observe = () => {
      this.controller.isVisible = !document.hidden;
      document.addEventListener(
        "visibilitychange",
        this.handleVisibilityChange
      );
      this.handleVisibilityChange();
    };
    this.unobserve = () => {
      document.removeEventListener(
        "visibilitychange",
        this.handleVisibilityChange
      );
    };
    this.becomesInvisible = (e) => {
      this.controller.isVisible = false;
      this.call("invisible", e);
      this.log("invisible", { isVisible: false });
      this.dispatch("invisible", { event: e, isVisible: false });
    };
    this.becomesVisible = (e) => {
      this.controller.isVisible = true;
      this.call("visible", e);
      this.log("visible", { isVisible: true });
      this.dispatch("visible", { event: e, isVisible: true });
    };
    this.handleVisibilityChange = (e) => {
      document.hidden ? this.becomesInvisible(e) : this.becomesVisible(e);
    };
    this.controller = e;
    this.enhanceController();
    this.observe();
  }
  enhanceController() {
    const e = this.controllerDisconnect;
    const disconnect = () => {
      this.unobserve();
      e();
    };
    Object.assign(this.controller, { disconnect: disconnect });
  }
}
const useVisibility = (e, t = {}) => {
  const s = e;
  const n = new UseVisibility(s, t);
  return [n.observe, n.unobserve];
};
class VisibilityComposableController extends e {
  constructor() {
    super(...arguments);
    this.isVisible = false;
  }
}
class VisibilityController extends VisibilityComposableController {
  constructor(e) {
    super(e);
    requestAnimationFrame(() => {
      const [e, t] = useVisibility(this, this.options);
      Object.assign(this, { observe: e, unobserve: t });
    });
  }
}
class UseHover extends StimulusUse {
  constructor(e, t = {}) {
    super(e, t);
    this.observe = () => {
      this.targetElement.addEventListener("mouseenter", this.onEnter);
      this.targetElement.addEventListener("mouseleave", this.onLeave);
    };
    this.unobserve = () => {
      this.targetElement.removeEventListener("mouseenter", this.onEnter);
      this.targetElement.removeEventListener("mouseleave", this.onLeave);
    };
    this.onEnter = (e) => {
      this.call("mouseEnter", e);
      this.log("mouseEnter", { hover: true });
      this.dispatch("mouseEnter", { hover: false });
    };
    this.onLeave = (e) => {
      this.call("mouseLeave", e);
      this.log("mouseLeave", { hover: false });
      this.dispatch("mouseLeave", { hover: false });
    };
    this.controller = e;
    this.enhanceController();
    this.observe();
  }
  enhanceController() {
    const e = this.controller.disconnect.bind(this.controller);
    const disconnect = () => {
      this.unobserve();
      e();
    };
    Object.assign(this.controller, { disconnect: disconnect });
  }
}
const useHover = (e, t = {}) => {
  const s = e;
  const n = new UseHover(s, t);
  return [n.observe, n.unobserve];
};
class HoverComposableController extends e {}
class HoverController extends HoverComposableController {
  constructor(e) {
    super(e);
    requestAnimationFrame(() => {
      const [e, t] = useHover(this, this.options);
      Object.assign(this, { observe: e, unobserve: t });
    });
  }
}
class UseMutation extends StimulusUse {
  constructor(e, t = {}) {
    super(e, t);
    this.observe = () => {
      try {
        this.observer.observe(this.targetElement, this.options);
      } catch (e) {
        this.controller.application.handleError(
          e,
          "At a minimum, one of childList, attributes, and/or characterData must be true",
          {}
        );
      }
    };
    this.unobserve = () => {
      this.observer.disconnect();
    };
    this.mutation = (e) => {
      this.call("mutate", e);
      this.log("mutate", { entries: e });
      this.dispatch("mutate", { entries: e });
    };
    this.targetElement =
      (null === t || void 0 === t ? void 0 : t.element) || e.element;
    this.controller = e;
    this.options = t;
    this.observer = new MutationObserver(this.mutation);
    this.enhanceController();
    this.observe();
  }
  enhanceController() {
    const e = this.controller.disconnect.bind(this.controller);
    const disconnect = () => {
      this.unobserve();
      e();
    };
    Object.assign(this.controller, { disconnect: disconnect });
  }
}
const useMutation = (e, t = {}) => {
  const s = new UseMutation(e, t);
  return [s.observe, s.unobserve];
};
class MutationComposableController extends e {}
class MutationController extends MutationComposableController {
  constructor(e) {
    super(e);
    requestAnimationFrame(() => {
      const [e, t] = useMutation(this, this.options);
      Object.assign(this, { observe: e, unobserve: t });
    });
  }
}
class UseTargetMutation extends StimulusUse {
  constructor(e, t = {}) {
    super(e, t);
    this.observe = () => {
      this.observer.observe(this.targetElement, {
        subtree: true,
        characterData: true,
        childList: true,
        attributes: true,
        attributeOldValue: true,
        attributeFilter: [this.targetSelector, this.scopedTargetSelector],
      });
    };
    this.unobserve = () => {
      this.observer.disconnect();
    };
    this.mutation = (e) => {
      for (const t of e)
        switch (t.type) {
          case "attributes":
            let e = t.target.getAttribute(t.attributeName);
            let s = t.oldValue;
            if (
              t.attributeName === this.targetSelector ||
              t.attributeName === this.scopedTargetSelector
            ) {
              let n = this.targetsUsedByThisController(s);
              let o = this.targetsUsedByThisController(e);
              let i = n.filter((e) => !o.includes(e));
              let r = o.filter((e) => !n.includes(e));
              i.forEach((e) =>
                this.targetRemoved(
                  this.stripIdentifierPrefix(e),
                  t.target,
                  "attributeChange"
                )
              );
              r.forEach((e) =>
                this.targetAdded(
                  this.stripIdentifierPrefix(e),
                  t.target,
                  "attributeChange"
                )
              );
            }
            break;
          case "characterData":
            let n = this.findTargetInAncestry(t.target);
            if (null == n) return;
            {
              let e = this.targetsUsedByThisControllerFromNode(n);
              e.forEach((e) => {
                this.targetChanged(
                  this.stripIdentifierPrefix(e),
                  n,
                  "domMutation"
                );
              });
            }
            break;
          case "childList":
            let { addedNodes: o, removedNodes: i } = t;
            o.forEach((e) => this.processNodeDOMMutation(e, this.targetAdded));
            i.forEach((e) =>
              this.processNodeDOMMutation(e, this.targetRemoved)
            );
            break;
        }
    };
    this.controller = e;
    this.options = t;
    this.targetElement = e.element;
    this.identifier = e.scope.identifier;
    this.identifierPrefix = `${this.identifier}.`;
    this.targetSelector = e.scope.schema.targetAttribute;
    this.scopedTargetSelector = `data-${this.identifier}-target`;
    this.targets = t.targets || e.constructor.targets;
    this.prefixedTargets = this.targets.map(
      (e) => `${this.identifierPrefix}${e}`
    );
    this.observer = new MutationObserver(this.mutation);
    this.enhanceController();
    this.observe();
  }
  processNodeDOMMutation(e, t) {
    let s = e;
    let n = t;
    let o = [];
    if (
      "#text" == s.nodeName ||
      0 == this.targetsUsedByThisControllerFromNode(s).length
    ) {
      n = this.targetChanged;
      s = this.findTargetInAncestry(e);
    } else o = this.targetsUsedByThisControllerFromNode(s);
    if (null != s) {
      0 == o.length && (o = this.targetsUsedByThisControllerFromNode(s));
      o.forEach((e) => {
        n.call(this, this.stripIdentifierPrefix(e), s, "domMutation");
      });
    }
  }
  findTargetInAncestry(e) {
    let t = e;
    let s = [];
    "#text" != t.nodeName && (s = this.targetsUsedByThisControllerFromNode(t));
    while (
      null !== t.parentNode &&
      t.parentNode != this.targetElement &&
      0 == s.length
    ) {
      t = t.parentNode;
      if ("#text" !== t.nodeName) {
        let e = this.targetsUsedByThisControllerFromNode(t);
        if (e.length > 0) return t;
      }
    }
    return "#text" == t.nodeName || null == t.parentNode
      ? null
      : t.parentNode == this.targetElement &&
        this.targetsUsedByThisControllerFromNode(t).length > 0
      ? t
      : null;
  }
  targetAdded(e, t, s) {
    let n = `${e}TargetAdded`;
    this.controller[n] && method(this.controller, n).call(this.controller, t);
    this.log("targetAdded", { target: e, node: t, trigger: s });
  }
  targetRemoved(e, t, s) {
    let n = `${e}TargetRemoved`;
    this.controller[n] && method(this.controller, n).call(this.controller, t);
    this.log("targetRemoved", { target: e, node: t, trigger: s });
  }
  targetChanged(e, t, s) {
    let n = `${e}TargetChanged`;
    this.controller[n] && method(this.controller, n).call(this.controller, t);
    this.log("targetChanged", { target: e, node: t, trigger: s });
  }
  targetsUsedByThisControllerFromNode(e) {
    if ("#text" == e.nodeName || "#comment" == e.nodeName) return [];
    let t = e;
    return this.targetsUsedByThisController(
      t.getAttribute(this.scopedTargetSelector) ||
        t.getAttribute(this.targetSelector)
    );
  }
  targetsUsedByThisController(e) {
    e = e || "";
    let t = this.stripIdentifierPrefix(e).split(" ");
    return this.targets.filter((e) => -1 !== t.indexOf(e));
  }
  stripIdentifierPrefix(e) {
    return e.replace(new RegExp(this.identifierPrefix, "g"), "");
  }
  enhanceController() {
    const e = this.controller.disconnect.bind(this.controller);
    const disconnect = () => {
      this.unobserve();
      e();
    };
    Object.assign(this.controller, { disconnect: disconnect });
  }
}
const useTargetMutation = (e, t = {}) => {
  const s = e;
  const n = new UseTargetMutation(s, t);
  return [n.observe, n.unobserve];
};
class TargetMutationComposableController extends e {}
class TargetMutationController extends TargetMutationComposableController {
  constructor(e) {
    super(e);
    requestAnimationFrame(() => {
      const [e, t] = useTargetMutation(this, this.options);
      Object.assign(this, { observe: e, unobserve: t });
    });
  }
}
const useWindowResize = (e) => {
  const t = e;
  const callback = (e) => {
    const { innerWidth: s, innerHeight: n } = window;
    const o = { height: n || Infinity, width: s || Infinity, event: e };
    method(t, "windowResize").call(t, o);
  };
  const s = t.disconnect.bind(t);
  const observe = () => {
    window.addEventListener("resize", callback);
    callback();
  };
  const unobserve = () => {
    window.removeEventListener("resize", callback);
  };
  Object.assign(t, {
    disconnect() {
      unobserve();
      s();
    },
  });
  observe();
  return [observe, unobserve];
};
class WindowResizeComposableController extends e {}
class WindowResizeController extends WindowResizeComposableController {
  constructor(e) {
    super(e);
    requestAnimationFrame(() => {
      const [e, t] = useWindowResize(this);
      Object.assign(this, { observe: e, unobserve: t });
    });
  }
}
const memoize = (e, t, s) => {
  Object.defineProperty(e, t, { value: s });
  return s;
};
const useMemo = (e) => {
  var t;
  null === (t = e.constructor.memos) || void 0 === t
    ? void 0
    : t.forEach((t) => {
        memoize(e, t, e[t]);
      });
};
class DebounceController extends e {}
DebounceController.debounces = [];
const u = 200;
const debounce = (e, t = u) => {
  let s = null;
  return function () {
    const n = Array.from(arguments);
    const o = this;
    const i = n.map((e) => e.params);
    const callback = () => {
      n.forEach((e, t) => (e.params = i[t]));
      return e.apply(o, n);
    };
    s && clearTimeout(s);
    s = setTimeout(callback, t);
  };
};
const useDebounce = (e, t) => {
  const s = e;
  const n = s.constructor;
  n.debounces.forEach((e) => {
    "string" === typeof e &&
      (s[e] = debounce(s[e], null === t || void 0 === t ? void 0 : t.wait));
    if ("object" === typeof e) {
      const { name: n, wait: o } = e;
      if (!n) return;
      s[n] = debounce(
        s[n],
        o || (null === t || void 0 === t ? void 0 : t.wait)
      );
    }
  });
};
class ThrottleController extends e {}
ThrottleController.throttles = [];
const d = 200;
function throttle(e, t = d) {
  let s;
  return function () {
    const n = arguments;
    const o = this;
    if (!s) {
      s = true;
      e.apply(o, n);
      setTimeout(() => (s = false), t);
    }
  };
}
const useThrottle = (e, t = {}) => {
  var s;
  const n = e;
  const o = n.constructor;
  null === (s = o.throttles) || void 0 === s
    ? void 0
    : s.forEach((e) => {
        "string" === typeof e &&
          (n[e] = throttle(n[e], null === t || void 0 === t ? void 0 : t.wait));
        if ("object" === typeof e) {
          const { name: s, wait: o } = e;
          if (!s) return;
          n[s] = throttle(
            n[s],
            o || (null === t || void 0 === t ? void 0 : t.wait)
          );
        }
      });
};
const defineMetaGetter = (e, t, s) => {
  const n = s ? `${camelize(t)}Meta` : camelize(t);
  Object.defineProperty(e, n, {
    get() {
      return typeCast(metaValue(t));
    },
  });
};
function metaValue(e) {
  const t = document.head.querySelector(`meta[name="${e}"]`);
  return t && t.getAttribute("content");
}
function typeCast(e) {
  try {
    return JSON.parse(e);
  } catch (t) {
    return e;
  }
}
const useMeta = (e, t = { suffix: true }) => {
  const s = e.constructor.metaNames;
  const n = t.suffix;
  null === s || void 0 === s
    ? void 0
    : s.forEach((t) => {
        defineMetaGetter(e, t, n);
      });
  Object.defineProperty(e, "metas", {
    get() {
      const e = {};
      null === s || void 0 === s
        ? void 0
        : s.forEach((t) => {
            const s = typeCast(metaValue(t));
            void 0 !== s && null !== s && (e[camelize(t)] = s);
          });
      return e;
    },
  });
};
const b = {
  enterFromClass: "enter",
  enterActiveClass: "enterStart",
  enterToClass: "enterEnd",
  leaveFromClass: "leave",
  leaveActiveClass: "leaveStart",
  leaveToClass: "leaveEnd",
};
const m = {
  transitioned: false,
  hiddenClass: "hidden",
  preserveOriginalClass: true,
  removeToClasses: true,
};
const useTransition = (e, t = {}) => {
  var s, n, o;
  const i = e;
  const r = i.element.dataset.transitionTarget;
  let l;
  r && (l = i[`${r}Target`]);
  const c = (null === t || void 0 === t ? void 0 : t.element) || l || i.element;
  if (!(c instanceof HTMLElement || c instanceof SVGElement)) return;
  const a = c.dataset;
  const h = parseInt(a.leaveAfter || "") || t.leaveAfter || 0;
  const {
    transitioned: u,
    hiddenClass: d,
    preserveOriginalClass: b,
    removeToClasses: v,
  } = Object.assign({}, m, t);
  const g = null === (s = i.enter) || void 0 === s ? void 0 : s.bind(i);
  const p = null === (n = i.leave) || void 0 === n ? void 0 : n.bind(i);
  const f =
    null === (o = i.toggleTransition) || void 0 === o ? void 0 : o.bind(i);
  async function enter(e) {
    if (i.transitioned) return;
    i.transitioned = true;
    g && g(e);
    const s = getAttribute("enterFrom", t, a);
    const n = getAttribute("enterActive", t, a);
    const o = getAttribute("enterTo", t, a);
    const r = getAttribute("leaveTo", t, a);
    !d || c.classList.remove(d);
    v || removeClasses(c, r);
    await transition(c, s, n, o, d, b, v);
    h > 0 &&
      setTimeout(() => {
        leave(e);
      }, h);
  }
  async function leave(e) {
    if (!i.transitioned) return;
    i.transitioned = false;
    p && p(e);
    const s = getAttribute("leaveFrom", t, a);
    const n = getAttribute("leaveActive", t, a);
    const o = getAttribute("leaveTo", t, a);
    const r = getAttribute("enterTo", t, a);
    v || removeClasses(c, r);
    await transition(c, s, n, o, d, b, v);
    !d || c.classList.add(d);
  }
  function toggleTransition(e) {
    f && f(e);
    i.transitioned ? leave() : enter();
  }
  async function transition(e, t, s, n, o, i, r) {
    const l = [];
    if (i) {
      t.forEach((t) => e.classList.contains(t) && t !== o && l.push(t));
      s.forEach((t) => e.classList.contains(t) && t !== o && l.push(t));
      n.forEach((t) => e.classList.contains(t) && t !== o && l.push(t));
    }
    addClasses(e, t);
    removeClasses(e, l);
    addClasses(e, s);
    await nextAnimationFrame();
    removeClasses(e, t);
    addClasses(e, n);
    await afterTransition(e);
    removeClasses(e, s);
    r && removeClasses(e, n);
    addClasses(e, l);
  }
  function initialState() {
    i.transitioned = u;
    if (u) {
      !d || c.classList.remove(d);
      enter();
    } else {
      !d || c.classList.add(d);
      leave();
    }
  }
  function addClasses(e, t) {
    t.length > 0 && e.classList.add(...t);
  }
  function removeClasses(e, t) {
    t.length > 0 && e.classList.remove(...t);
  }
  initialState();
  Object.assign(i, {
    enter: enter,
    leave: leave,
    toggleTransition: toggleTransition,
  });
  return [enter, leave, toggleTransition];
};
function getAttribute(e, t, s) {
  const n = `transition${e[0].toUpperCase()}${e.substr(1)}`;
  const o = b[e];
  const i = t[e] || s[n] || s[o] || " ";
  return isEmpty(i) ? [] : i.split(" ");
}
async function afterTransition(e) {
  return new Promise((t) => {
    const s =
      1e3 *
      Number(
        getComputedStyle(e).transitionDuration.split(",")[0].replace("s", "")
      );
    setTimeout(() => {
      t(s);
    }, s);
  });
}
async function nextAnimationFrame() {
  return new Promise((e) => {
    requestAnimationFrame(() => {
      requestAnimationFrame(e);
    });
  });
}
function isEmpty(e) {
  return 0 === e.length || !e.trim();
}
class TransitionComposableController extends e {
  constructor() {
    super(...arguments);
    this.transitioned = false;
  }
}
class TransitionController extends TransitionComposableController {
  constructor(e) {
    super(e);
    requestAnimationFrame(() => {
      useTransition(this, this.options);
    });
  }
}
class UseHotkeys extends StimulusUse {
  constructor(e, s) {
    super(e, s);
    this.bind = () => {
      for (const [e, s] of Object.entries(this.hotkeysOptions.hotkeys)) {
        const n = s.handler.bind(this.controller);
        t(e, s.options, (e) => n(e, e));
      }
    };
    this.unbind = () => {
      for (const e in this.hotkeysOptions.hotkeys) t.unbind(e);
    };
    this.controller = e;
    this.hotkeysOptions = s;
    this.enhanceController();
    this.bind();
  }
  enhanceController() {
    this.hotkeysOptions.filter && (t.filter = this.hotkeysOptions.filter);
    const e = this.controller.disconnect.bind(this.controller);
    const disconnect = () => {
      this.unbind();
      e();
    };
    Object.assign(this.controller, { disconnect: disconnect });
  }
}
const convertSimpleHotkeyDefinition = (e) => ({
  handler: e[0],
  options: { element: e[1] },
});
const coerceOptions = (e) => {
  if (!e.hotkeys) {
    const t = {};
    Object.entries(e).forEach(([e, s]) => {
      Object.defineProperty(t, e, {
        value: convertSimpleHotkeyDefinition(s),
        writable: false,
        enumerable: true,
      });
    });
    e = { hotkeys: t };
  }
  return e;
};
const useHotkeys = (e, t) => new UseHotkeys(e, coerceOptions(t));
const v = {
  mediaQueries: {},
  dispatchEvent: true,
  eventPrefix: true,
  debug: false,
};
class UseMatchMedia extends StimulusUse {
  constructor(e, t = {}) {
    var s, n, o, i;
    super(e, t);
    this.matches = [];
    this.callback = (e) => {
      const t = Object.keys(this.mediaQueries).find(
        (t) => this.mediaQueries[t] === e.media
      );
      if (!t) return;
      const { media: s, matches: n } = e;
      this.changed({ name: t, media: s, matches: n, event: e });
    };
    this.changed = (e) => {
      const { name: t } = e;
      if (e.event) {
        this.call(camelize(`${t}_changed`), e);
        this.dispatch(`${t}:changed`, e);
        this.log(`media query "${t}" changed`, e);
      }
      if (e.matches) {
        this.call(camelize(`is_${t}`), e);
        this.dispatch(`is:${t}`, e);
      } else {
        this.call(camelize(`not_${t}`), e);
        this.dispatch(`not:${t}`, e);
      }
    };
    this.observe = () => {
      Object.keys(this.mediaQueries).forEach((e) => {
        const t = this.mediaQueries[e];
        const s = window.matchMedia(t);
        s.addListener(this.callback);
        this.matches.push(s);
        this.changed({ name: e, media: t, matches: s.matches });
      });
    };
    this.unobserve = () => {
      this.matches.forEach((e) => e.removeListener(this.callback));
    };
    this.controller = e;
    this.mediaQueries =
      null !== (s = t.mediaQueries) && void 0 !== s ? s : v.mediaQueries;
    this.dispatchEvent =
      null !== (n = t.dispatchEvent) && void 0 !== n ? n : v.dispatchEvent;
    this.eventPrefix =
      null !== (o = t.eventPrefix) && void 0 !== o ? o : v.eventPrefix;
    this.debug = null !== (i = t.debug) && void 0 !== i ? i : v.debug;
    if (window.matchMedia) {
      this.enhanceController();
      this.observe();
    } else console.error("window.matchMedia() is not available");
  }
  enhanceController() {
    const e = this.controller.disconnect.bind(this.controller);
    const disconnect = () => {
      this.unobserve();
      e();
    };
    Object.assign(this.controller, { disconnect: disconnect });
  }
}
const useMatchMedia = (e, t = {}) => {
  const s = new UseMatchMedia(e, t);
  return [s.observe, s.unobserve];
};
class UseWindowFocus extends StimulusUse {
  constructor(e, t = {}) {
    super(e, t);
    this.observe = () => {
      document.hasFocus() ? this.becomesFocused() : this.becomesUnfocused();
      this.interval = setInterval(() => {
        this.handleWindowFocusChange();
      }, this.intervalDuration);
    };
    this.unobserve = () => {
      clearInterval(this.interval);
    };
    this.becomesUnfocused = (e) => {
      this.controller.hasFocus = false;
      this.call("unfocus", e);
      this.log("unfocus", { hasFocus: false });
      this.dispatch("unfocus", { event: e, hasFocus: false });
    };
    this.becomesFocused = (e) => {
      this.controller.hasFocus = true;
      this.call("focus", e);
      this.log("focus", { hasFocus: true });
      this.dispatch("focus", { event: e, hasFocus: true });
    };
    this.handleWindowFocusChange = (e) => {
      document.hasFocus() && !this.controller.hasFocus
        ? this.becomesFocused(e)
        : !document.hasFocus() &&
          this.controller.hasFocus &&
          this.becomesUnfocused(e);
    };
    this.controller = e;
    this.intervalDuration = t.interval || 200;
    this.enhanceController();
    this.observe();
  }
  enhanceController() {
    const e = this.controllerDisconnect;
    const disconnect = () => {
      this.unobserve();
      e();
    };
    Object.assign(this.controller, { disconnect: disconnect });
  }
}
const useWindowFocus = (e, t = {}) => {
  const s = e;
  const n = new UseWindowFocus(s, t);
  return [n.observe, n.unobserve];
};
class WindowFocusComposableController extends e {
  constructor() {
    super(...arguments);
    this.hasFocus = false;
  }
}
class WindowFocusController extends WindowFocusComposableController {
  constructor(e) {
    super(e);
    requestAnimationFrame(() => {
      const [e, t] = useWindowFocus(this, this.options);
      Object.assign(this, { observe: e, unobserve: t });
    });
  }
}
export {
  ApplicationController,
  ClickOutsideController,
  HoverController,
  IdleController,
  IntersectionController,
  LazyLoadController,
  MutationController,
  ResizeController,
  TargetMutationController,
  TransitionController,
  UseHover,
  UseMutation,
  UseTargetMutation,
  UseVisibility,
  VisibilityController,
  WindowFocusController,
  WindowResizeController,
  useApplication,
  useClickOutside,
  useDebounce,
  useDispatch,
  useHotkeys,
  useHover,
  useIdle,
  useIntersection,
  useLazyLoad,
  useMatchMedia,
  useMemo,
  useMeta,
  useMutation,
  useResize,
  useTargetMutation,
  useThrottle,
  useTransition,
  useVisibility,
  useWindowFocus,
  useWindowResize,
};
