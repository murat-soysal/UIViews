/* ============================================================
   iOSViews - plain HTML app (no frameworks)
   Hash-based routing:  #/all  |  #/:category  |  #/:category/:slug  |  legacy #/view/:slug
   ============================================================ */
(function () {
  "use strict";

  var DATA_BASE = ".";
  var REPO_URL = "https://github.com/murat-soysal/iOSViews/";
  var THEME_KEY = "uiviews_theme";
  var SITE_TITLE = "iOSViews";
  var CATEGORY_NAMES = { "food-drink": "Food & Drink" };
  var CATEGORY_ICONS = {
    all: "layout-grid",
    education: "graduation-cap",
    entertainment: "clapperboard",
    finance: "wallet",
    "food-drink": "utensils",
    news: "newspaper",
    onboarding: "rocket",
    productivity: "zap",
    settings: "settings",
    "social-feed": "message-circle",
  };

  var state = {
    catalog: [],
    viewMeta: {},
    codeCache: {},
  };

  /* ---------- helpers ---------- */
  function humanize(slug) {
    return slug
      .split("-")
      .map(function (w) {
        return w.charAt(0).toUpperCase() + w.slice(1);
      })
      .join(" ");
  }

  function el(html) {
    var t = document.createElement("template");
    t.innerHTML = html.trim();
    return t.content.firstChild;
  }

  function escapeHtml(text) {
    return String(text)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function displayUrl(url) {
    return String(url || "")
      .replace(/^https?:\/\//i, "")
      .replace(/^www\./i, "")
      .replace(/\/+$/, "");
  }

  function lucideIcon(name, size) {
    return (
      '<i data-lucide="' + name + '" class="' + size + '"></i>'
    );
  }

  function categoryIcon(slug) {
    return lucideIcon(CATEGORY_ICONS[slug] || "layout-grid", "h-4 w-4");
  }

  function mountIcons() {
    if (window.lucide) lucide.createIcons();
  }

  function viewDir(entry) {
    return DATA_BASE + "/views/" + entry.path;
  }

  async function fetchJson(url) {
    var res = await fetch(url);
    if (!res.ok) throw new Error("Failed to fetch " + url + " (" + res.status + ")");
    return res.json();
  }

  async function fetchText(url) {
    var res = await fetch(url);
    if (!res.ok) return "";
    return res.text();
  }

  /* ---------- data loading ---------- */
  function loadCatalog() {
    var json = window.CATALOG;
    state.catalog = Array.isArray(json) ? json : (json && json.views) || [];
  }

  function categories() {
    var seen = {};
    var out = [];
    state.catalog.forEach(function (entry) {
      if (!seen[entry.category]) {
        seen[entry.category] = true;
        out.push({
          slug: entry.category,
          name: CATEGORY_NAMES[entry.category] || humanize(entry.category),
        });
      }
    });
    return out;
  }

  async function getViewMeta(entry) {
    if (state.viewMeta[entry.slug]) return state.viewMeta[entry.slug];
    var meta = {};
    try {
      meta = await fetchJson(viewDir(entry) + "/metadata.json");
    } catch (e) {
      /* fall back to defaults */
    }
    var view = {
      slug: entry.slug,
      category: entry.category,
      path: entry.path,
      title: meta.title || humanize(entry.slug),
      authorUrl: meta.author_url || REPO_URL,
      preview: viewDir(entry) + "/preview.png",
    };
    state.viewMeta[entry.slug] = view;
    return view;
  }

  function getViewCode(view) {
    if (state.codeCache[view.slug] !== undefined) {
      return Promise.resolve(state.codeCache[view.slug]);
    }
    return fetchText(viewDir({ path: view.path }) + "/view.swift").then(function (
      code
    ) {
      state.codeCache[view.slug] = code;
      return code;
    });
  }

  function entriesByCategory(category) {
    if (category === "all") return state.catalog.slice();
    return state.catalog.filter(function (entry) {
      return entry.category === category;
    });
  }

  function entryBySlug(slug) {
    return state.catalog.find(function (entry) {
      return entry.slug === slug;
    });
  }

  /* ---------- routing ---------- */
  function parseHash() {
    var h = window.location.hash;
    if (!h || h === "#" || h === "#/") return { name: "category", slug: "all" };
    var parts = h.replace(/^#\/?/, "").split("/").filter(Boolean);
    if (parts[0] === "view" && parts[1]) {
      return { name: "view", slug: decodeURIComponent(parts[1]) };
    }
    if (parts.length === 2) {
      return {
        name: "view",
        slug: decodeURIComponent(parts[1]),
        category: decodeURIComponent(parts[0]),
      };
    }
    if (parts.length === 1) {
      return { name: "category", slug: decodeURIComponent(parts[0]) };
    }
    return { name: "notfound" };
  }

  function activeCategorySlug(route) {
    if (route.name === "category") return route.slug;
    if (route.name === "view") {
      var entry = entryBySlug(route.slug);
      return entry ? entry.category : "all";
    }
    return "";
  }

  /* ---------- DOM refs ---------- */
  var mainEl = document.getElementById("main-content");
  var sidebarEl = document.getElementById("sidebar");
  var overlayEl = document.getElementById("sidebar-overlay");
  var menuToggle = document.getElementById("menu-toggle");
  var themeButtons = [
    document.getElementById("theme-toggle-header"),
    document.getElementById("theme-toggle-sidebar"),
  ];

  /* ---------- theme ---------- */
  function applyTheme(mode) {
    document.documentElement.classList.toggle("dark", mode === "dark");
    var name = mode === "dark" ? "moon" : "sun";
    themeButtons.forEach(function (btn) {
      if (btn) btn.innerHTML = lucideIcon(name, "h-4 w-4");
    });
    mountIcons();
  }

  function initTheme() {
    var stored = localStorage.getItem(THEME_KEY);
    applyTheme(stored === "dark" ? "dark" : "light");
    themeButtons.forEach(function (btn) {
      if (btn) {
        btn.addEventListener("click", function () {
          var next =
            document.documentElement.classList.contains("dark")
              ? "light"
              : "dark";
          localStorage.setItem(THEME_KEY, next);
          applyTheme(next);
        });
      }
    });
  }

  /* ---------- sidebar ---------- */
  var NAV_ITEM_BASE =
    "nav-item flex items-center gap-2.5 rounded-full px-3 py-2 text-[13px] " +
    "text-slate-500 hover:bg-black/5 hover:text-slate-700 " +
    "dark:text-slate-400 dark:hover:bg-white/10 dark:hover:text-slate-200";

  function buildNav() {
    var nav = document.getElementById("category-nav");
    nav.innerHTML = "";
    var pad = document.createElement("div");
    pad.className = "px-2.5";
    var list = document.createElement("div");
    list.className = "flex flex-col gap-0.5";

    var allLink = el(
      '<a href="#/all" class="' + NAV_ITEM_BASE + '" data-nav="all">' +
        lucideIcon("layout-grid", "h-4 w-4 shrink-0") + "<span>All</span></a>"
    );
    list.appendChild(allLink);

    categories().forEach(function (cat) {
      var link = el(
        '<a href="#/' + cat.slug + '" class="' + NAV_ITEM_BASE +
          '" data-nav="' + cat.slug + '">' +
          lucideIcon(CATEGORY_ICONS[cat.slug] || "layout-grid", "h-4 w-4 shrink-0") +
          "<span>" + escapeHtml(cat.name) + "</span></a>"
      );
      list.appendChild(link);
    });

    pad.appendChild(list);
    nav.appendChild(pad);
  }

  function setActiveNav(route) {
    var slug = activeCategorySlug(route);
    document.querySelectorAll(".nav-item").forEach(function (item) {
      var active = item.dataset.nav === slug;
      item.classList.toggle("bg-white/80", active);
      item.classList.toggle("text-blue-600", active);
      item.classList.toggle("shadow-sm", active);
      item.classList.toggle("dark:bg-white/10", active);
      item.classList.toggle("dark:text-blue-300", active);
      item.classList.toggle("text-slate-500", !active);
      item.classList.toggle("dark:text-slate-400", !active);
    });
  }

  /* ---------- mobile menu ---------- */
  function closeMobileMenu() {
    sidebarEl.classList.remove("mobile-sidebar-open");
    overlayEl.hidden = true;
    menuToggle.setAttribute("aria-expanded", "false");
  }

  function initMobileMenu() {
    menuToggle.addEventListener("click", function () {
      var open = sidebarEl.classList.toggle("mobile-sidebar-open");
      overlayEl.hidden = !open;
      menuToggle.setAttribute("aria-expanded", String(open));
    });
    overlayEl.addEventListener("click", closeMobileMenu);
  }

  /* ---------- rendering: states ---------- */
  function pageContainer() {
    var page = document.createElement("div");
    page.className = "page flex flex-col p-6";
    return page;
  }

  function loadingState(label) {
    return el(
      '<div class="flex flex-1 items-center justify-center p-24 text-center">' +
        '<p class="text-[13px] text-slate-400">' +
        escapeHtml(label || "Loading…") + "</p></div>"
    );
  }

  function errorState(message) {
    return el(
      '<div class="flex flex-1 items-center justify-center p-24 text-center">' +
        '<div><p class="mb-1 text-[15px] font-medium text-red-500">Something went wrong</p>' +
        '<p class="text-[13px] text-slate-400">' + escapeHtml(message || "") +
        "</p></div></div>"
    );
  }

  function notFoundView() {
    return el(
      '<div class="flex flex-1 flex-col items-center justify-center p-6 text-center">' +
        '<p class="mb-1 text-[15px] font-semibold text-slate-700 dark:text-slate-200">Page not found</p>' +
        '<p class="text-[13px] text-slate-400">The page you are looking for doesn\'t exist.</p>' +
        '<a href="#/all" class="mt-4 text-[13px] font-medium text-blue-600 hover:text-blue-700">Back to Home</a></div>'
    );
  }

  /* ---------- rendering: cards ---------- */
  function viewCard(view) {
    var card = el(
      '<div class="break-inside-avoid">' +
        '<a href="#/' + view.category + '/' + view.slug + '" class="block">' +
        '<div class="relative overflow-hidden rounded-2xl bg-[#e8edf3] transition-transform duration-200 hover:-translate-y-0.5 hover:shadow-xl dark:bg-[#1f1f22]">' +
        '<div class="flex aspect-[100/185] items-center justify-center px-2">' +
        '<div class="relative w-[78%] shrink-0 overflow-hidden rounded-[15%/7%] bg-[#1a1a1a] shadow-md dark:border dark:border-white/15">' +
        '<div class="aspect-[9/19]"></div>' +
        '<div class="absolute inset-[3px] rounded-[13.5%/6.3%] bg-cover bg-center" ' +
        'style="background-image:url(\'' + view.preview + '\')"></div>' +
        "</div></div></div></a>" +
        '<div class="mt-2"><div class="flex items-center gap-1.5">' +
        '<a href="' + view.authorUrl + '" target="_blank" rel="noreferrer" ' +
        'class="flex h-5 w-5 shrink-0 items-center justify-center rounded-md bg-slate-100 text-slate-400 dark:bg-white/10 dark:text-slate-500" title="' +
        escapeHtml(displayUrl(view.authorUrl)) + '">' + lucideIcon("user-round", "h-3 w-3") + "</a>" +
        '<div class="min-w-0"><a href="#/' + view.category + '/' + view.slug +
        '" class="line-clamp-2 block text-[13px] font-semibold leading-tight text-slate-800 transition-colors hover:text-blue-600 dark:text-slate-200 dark:hover:text-blue-300">' +
        escapeHtml(view.title) + "</a></div>" +
        "</div></div></div>"
    );
    return card;
  }

  function viewGrid(views) {
    var grid = el(
      '<div class="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4"></div>'
    );
    views.forEach(function (view) {
      grid.appendChild(viewCard(view));
    });
    return grid;
  }

  /* ---------- rendering: category page ---------- */
  function pageHeader(title, iconSlug) {
    return el(
      '<div class="mb-6 flex shrink-0 items-center gap-2.5 border-b border-black/5 pb-4 dark:border-white/10">' +
        '<span class="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-black/5 text-slate-500 dark:bg-white/10">' +
        categoryIcon(iconSlug) + "</span>" +
        "<h1 class='text-xl font-semibold text-slate-800 dark:text-slate-200'>" +
        escapeHtml(title) + "</h1></div>"
    );
  }

  async function renderCategoryPage(slug, main) {
    if (slug === "all") {
      renderGridPage(main, "All Views", "all", slug);
    } else {
      var cat = categories().find(function (c) {
        return c.slug === slug;
      });
      if (!cat) {
        document.title = "Page not found · " + SITE_TITLE;
        var page = pageContainer();
        page.appendChild(notFoundView());
        main.innerHTML = "";
        main.appendChild(page);
        return;
      }
      renderGridPage(main, cat.name, cat.slug, slug);
    }
  }

  async function renderGridPage(main, title, iconSlug, category) {
    document.title = title + " · " + SITE_TITLE;
    var page = pageContainer();
    page.appendChild(pageHeader(title, iconSlug));
    page.appendChild(loadingState("Loading…"));
    main.innerHTML = "";
    main.appendChild(page);

    try {
      var entries = entriesByCategory(category);
      var views = await Promise.all(entries.map(getViewMeta));
      page.innerHTML = "";
      page.appendChild(pageHeader(title, iconSlug));
      if (views.length === 0) {
        page.appendChild(
          el(
            '<div class="flex flex-col items-center justify-center p-24 text-center">' +
              '<p class="mb-1 text-[15px] font-medium text-slate-600 dark:text-slate-300">No views found</p>' +
              '<p class="text-[13px] text-slate-400">No views in this category yet.</p></div>'
          )
        );
      } else {
        page.appendChild(viewGrid(views));
      }
      mountIcons();
    } catch (e) {
      page.appendChild(errorState(e.message));
      mountIcons();
    }
  }

  /* ---------- rendering: view page ---------- */
  function highlightSwift(code) {
    if (window.hljs && hljs.getLanguage("swift")) {
      return hljs.highlight(code, {
        language: "swift",
        ignoreIllegals: true,
      }).value;
    }
    return escapeHtml(code);
  }

  function buildCodePanel(code) {
    var htmlLines = highlightSwift(code).split("\n");

    var panel = el(
      '<div class="absolute bottom-4 right-4 top-4 left-auto z-10 flex w-[60%] min-h-0 flex-col overflow-hidden rounded-xl bg-white/95 shadow-2xl backdrop-blur max-lg:inset-0 max-lg:w-auto max-lg:rounded-none max-lg:border-0 max-lg:[&.mobile-hidden]:hidden dark:border dark:border-white/10 dark:bg-[#27272a]/95">' +
        '<div class="flex h-7 shrink-0 items-center gap-1.5 border-b border-black/5 bg-[#f5f5f7] px-3 text-xs text-neutral-500 select-none dark:border-white/10 dark:bg-[#303033] dark:text-slate-300">' +
        '<div class="flex gap-1.5" aria-hidden="true">' +
        '<span class="h-2.5 w-2.5 rounded-full" style="background:#ff5f57"></span>' +
        '<span class="h-2.5 w-2.5 rounded-full" style="background:#febc2e"></span>' +
        '<span class="h-2.5 w-2.5 rounded-full" style="background:#28c840"></span></div>' +
        '<div class="flex-1"></div>' +
        '<span class="text-[11px] uppercase tracking-wide text-slate-400 dark:text-slate-500">Swift</span>' +
        "</div>" +
        '<div class="group/copy relative flex min-h-0 flex-1 flex-col">' +
        '<div class="code-scroll relative min-h-0 flex-1 overflow-auto bg-white dark:bg-[#18181b]" id="code-scroll"></div>' +
        '<button type="button" class="absolute bottom-3 right-3 z-20 flex items-center gap-1.5 rounded-xl bg-white/90 px-3 py-2 text-xs font-semibold text-slate-500 opacity-0 shadow-md transition hover:scale-105 group-hover/copy:opacity-100 dark:bg-[#3f3f46] dark:text-slate-100" id="copy-button">' +
        lucideIcon("clipboard", "h-3.5 w-3.5") + "<span>Copy</span></button>" +
        "</div></div>"
    );

    var scroll = panel.querySelector("#code-scroll");
    var copyBtn = panel.querySelector("#copy-button");

    /* render lines */
    htmlLines.forEach(function (htmlLine, i) {
      var row = document.createElement("div");
      row.className =
        "flex font-mono text-[13px] leading-[1.6] text-slate-800 dark:text-slate-200";
      var num = document.createElement("span");
      num.className =
        "w-11 shrink-0 pr-3 text-right text-slate-400 select-none dark:text-slate-500";
      num.textContent = String(i + 1);
      var text = document.createElement("code");
      text.className = "whitespace-pre pr-4";
      text.innerHTML = htmlLine === "" ? " " : htmlLine;
      row.appendChild(num);
      row.appendChild(text);
      scroll.appendChild(row);
    });

    /* copy */
    copyBtn.addEventListener("click", function () {
      copyText(code).then(function (ok) {
        if (!ok) return;
        copyBtn.classList.add("!opacity-100", "bg-green-600", "text-white");
        copyBtn.innerHTML = lucideIcon("check", "h-3.5 w-3.5") + "<span>Copied</span>";
        mountIcons();
        setTimeout(function () {
          copyBtn.classList.remove("!opacity-100", "bg-green-600", "text-white");
          copyBtn.innerHTML = lucideIcon("clipboard", "h-3.5 w-3.5") + "<span>Copy</span>";
          mountIcons();
        }, 1500);
      });
    });

    return panel;
  }

  function copyText(text) {
    if (navigator.clipboard && window.isSecureContext) {
      return navigator.clipboard.writeText(text).then(
        function () {
          return true;
        },
        function () {
          return legacyCopy(text);
        }
      );
    }
    return Promise.resolve(legacyCopy(text));
  }

  function legacyCopy(text) {
    try {
      var ta = document.createElement("textarea");
      ta.value = text;
      ta.style.position = "fixed";
      ta.style.opacity = "0";
      document.body.appendChild(ta);
      ta.select();
      var ok = document.execCommand("copy");
      document.body.removeChild(ta);
      return ok;
    } catch (e) {
      return false;
    }
  }

  function buildPreviewStage(view) {
    return el(
      '<div class="absolute inset-y-0 left-0 right-[60%] flex items-center justify-center max-lg:right-0 max-lg:[&.mobile-hidden]:hidden">' +
        '<div class="relative aspect-[1206/2622] max-h-[80vh] w-[220px] shrink-0 overflow-hidden rounded-[15%/7%] bg-white shadow-[0_0_0_4px_#3a3a3a,0_0_0_6px_#555,0_16px_50px_rgba(0,0,0,0.5)] max-lg:w-[180px] max-lg:shadow-[0_0_0_3px_#3a3a3a,0_0_0_5px_#555,0_12px_40px_rgba(0,0,0,0.4)]">' +
        '<div class="absolute inset-0 overflow-hidden rounded-[13.5%/6.3%] bg-cover bg-center" style="background-image:url(\'' +
        view.preview + '\')"></div></div></div>'
    );
  }

  async function renderViewPage(slug, main) {
    var page = pageContainer();
    page.classList.add("view-page");
    page.appendChild(loadingState("Loading view…"));
    main.innerHTML = "";
    main.appendChild(page);

    var entry;
    try {
      entry = entryBySlug(slug);
      if (!entry) throw new Error("not-found");
      var view = await getViewMeta(entry);
      document.title = view.title + " · " + SITE_TITLE;
      var code = await getViewCode(view);

      page.innerHTML = "";
      page.appendChild(
        el(
          '<div class="mb-5 flex shrink-0 items-center gap-2.5 rounded-2xl bg-gradient-to-br from-slate-100 to-white p-2 shadow-sm dark:border dark:border-white/20 dark:from-[#18181b] dark:to-[#27272a]">' +
            '<a href="#/' + view.category + '" class="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-white text-slate-600 shadow-sm transition-colors hover:bg-slate-100 dark:bg-[#27272a] dark:text-slate-300 dark:hover:bg-[#3f3f46]" aria-label="' +
            escapeHtml(humanize(view.category)) + '" title="' +
            escapeHtml(humanize(view.category)) + '">' +
            lucideIcon("arrow-left", "h-4 w-4") + "</a>" +
            '<div class="min-w-0 flex-1"><h1 class="truncate text-[15px] font-semibold leading-snug text-slate-800 dark:text-slate-100">' +
            escapeHtml(view.title) + "</h1>" +
            '<p class="mt-0.5 flex items-center gap-1 text-xs text-slate-400 dark:text-slate-500">' +
            lucideIcon(CATEGORY_ICONS[view.category] || "layout-grid", "h-3 w-3") +
            '<span class="truncate">' + escapeHtml(humanize(view.category)) + "</span></p></div>" +
            '<a href="' + view.authorUrl + '" target="_blank" rel="noreferrer" ' +
            'class="flex shrink-0 items-center gap-1.5 rounded-full bg-white px-3 py-1.5 text-xs font-medium text-slate-600 shadow-sm transition-colors hover:bg-slate-100 dark:bg-[#27272a] dark:text-slate-300 dark:hover:bg-[#3f3f46]" ' +
            'title="' + escapeHtml(displayUrl(view.authorUrl)) + '">' +
            lucideIcon("user-round", "h-3.5 w-3.5") +
            '<span class="max-w-[180px] truncate">' + escapeHtml(displayUrl(view.authorUrl)) + "</span></a>" +
            "</div>"
        )
      );

      /* panel */
      var panel = el(
        '<div class="flex min-h-[74vh] flex-1 flex-col overflow-hidden rounded-xl bg-[#e8edf3] dark:bg-[#1f1f22]">' +
          '<div class="hidden gap-1 border-b border-black/5 bg-white/70 p-1.5 max-lg:flex dark:border-white/10 dark:bg-[#303033]" role="tablist" aria-label="View mode">' +
          '<button type="button" role="tab" class="mobile-panel-tab flex-1 rounded-lg px-2.5 py-[7px] text-xs font-semibold transition bg-white text-blue-600 shadow dark:bg-[#3f3f46] dark:text-blue-300" data-panel="preview">Preview</button>' +
          '<button type="button" role="tab" class="mobile-panel-tab flex-1 rounded-lg px-2.5 py-[7px] text-xs font-semibold text-slate-500 transition dark:text-slate-400" data-panel="code">Code</button></div>' +
          '<div class="panel-body relative min-h-0 flex-1 overflow-hidden"></div></div>'
      );
      var body = panel.querySelector(".panel-body");
      var codePanel = buildCodePanel(code);
      var previewStage = buildPreviewStage(view);
      body.appendChild(previewStage);
      body.appendChild(codePanel);
      page.appendChild(panel);

      /* mobile tabs */
      var tabs = panel.querySelectorAll(".mobile-panel-tab");
      var mobilePanel = "preview";
      tabs.forEach(function (tab) {
        tab.addEventListener("click", function () {
          mobilePanel = tab.dataset.panel;
          tabs.forEach(function (t) {
            var on = t === tab;
            t.classList.toggle("bg-white", on);
            t.classList.toggle("text-blue-600", on);
            t.classList.toggle("shadow", on);
            t.classList.toggle("dark:bg-[#3f3f46]", on);
            t.classList.toggle("dark:text-blue-300", on);
            t.classList.toggle("text-slate-500", !on);
            t.classList.toggle("dark:text-slate-400", !on);
          });
          codePanel.classList.toggle("mobile-hidden", mobilePanel !== "code");
          previewStage.classList.toggle("mobile-hidden", mobilePanel !== "preview");
        });
      });
      if (window.innerWidth < 1024) {
        codePanel.classList.add("mobile-hidden");
        previewStage.classList.remove("mobile-hidden");
      }

      mountIcons();
    } catch (e) {
      if (e.message === "not-found") {
        document.title = "Page not found · " + SITE_TITLE;
        page.innerHTML = "";
        page.appendChild(notFoundView());
      } else {
        page.appendChild(errorState(e.message));
      }
      mountIcons();
    }
  }

  /* ---------- route dispatch ---------- */
  function route() {
    var r = parseHash();
    setActiveNav(r);
    closeMobileMenu();
    mainEl.innerHTML = "";
    if (r.name === "category") renderCategoryPage(r.slug, mainEl);
    else if (r.name === "view") renderViewPage(r.slug, mainEl);
    else {
      document.title = "Page not found · " + SITE_TITLE;
      mainEl.appendChild(notFoundView());
      mountIcons();
    }
  }

  /* ---------- init ---------- */
  function init() {
    initTheme();
    initMobileMenu();
    loadCatalog();
    buildNav();
    setActiveNav(parseHash());
    window.addEventListener("hashchange", route);
    mountIcons();
    route();
  }

  init();
})();
