<script>
  import "../app.css"
  import { page } from "$app/stores"
  import { clickOutside } from "$lib/clickOutside.js"

  const title = "BundesBattle Season 1"
  const description =
    "The Swiss Street Fighter 6 league with offline qualifiers in Basel and Zürich!"
  const url = "https://bundesbattle.ch/"
  const banner = url + "images/bundesbattle-banner.png"

  let mobileMenuOpen = false
</script>

<svelte:head>
  <title>{title}</title>
  <meta name="title" content={title} />
  <meta name="description" content={description} />

  <!-- Open Graph / Facebook -->
  <meta property="og:type" content="website" />
  <meta property="og:url" content={url} />
  <meta property="og:title" content={title} />
  <meta property="og:description" content={description} />
  <meta property="og:image" content={banner} />

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image" />
  <meta property="twitter:url" content={url} />
  <meta property="twitter:title" content={title} />
  <meta property="twitter:description" content={description} />
  <meta property="twitter:image" content={banner} />
</svelte:head>

<nav
  class="bg-neutral-800"
  use:clickOutside
  on:click_outside={() => (mobileMenuOpen = false)}
>
  <div class="px-2 mx-auto max-w-7xl lg:px-8">
    <div class="flex relative justify-between items-center h-16">
      <div class="flex absolute inset-y-0 left-0 items-center">
        <div class="hidden lg:ml-6 lg:block">
          <div class="flex space-x-4">
            <a
              href="/basel"
              class="px-3 py-2 text-sm font-medium rounded-md hover:bg-bbyellow hover:text-slate-800 aria-current:bg-bbyellow aria-current:text-slate-800"
              aria-current={$page.url.pathname === "/basel"}>Basel</a
            >
            <a
              href="/zurich"
              class="px-3 py-2 text-sm font-medium rounded-md hover:bg-bbyellow hover:text-slate-800 aria-current:bg-bbyellow aria-current:text-slate-800"
              aria-current={$page.url.pathname === "/zurich"}>Zürich</a
            >
            <a
              href="/direct-qualifiers"
              class="px-3 py-2 text-sm font-medium rounded-md hover:bg-bbyellow hover:text-slate-800 aria-current:bg-bbyellow aria-current:text-slate-800"
              aria-current={$page.url.pathname === "/direct-qualifiers"}
              >Direct Qualifiers</a
            >
            <a
              href="/finals"
              class="px-3 py-2 text-sm font-medium rounded-md hover:bg-bbyellow hover:text-slate-800 aria-current:bg-bbyellow aria-current:text-slate-800"
              aria-current={$page.url.pathname === "/finals"}>Finals</a
            >
          </div>
        </div>

        <!-- Mobile menu button-->
        <button
          type="button"
          class="inline-flex relative justify-center items-center p-2 rounded-md hover:bg-bbyellow lg:hidden hover:text-slate-800"
          aria-controls="mobile-menu"
          aria-expanded="false"
          on:click={() => (mobileMenuOpen = !mobileMenuOpen)}
        >
          <span class="absolute -inset-0.5" />
          <span class="sr-only">Open main menu</span>
          {#if mobileMenuOpen}
            <svg
              class="block w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              aria-hidden="true"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M6 18L18 6M6 6l12 12"
              />
            </svg>
          {:else}
            <svg
              class="block w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              aria-hidden="true"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"
              />
            </svg>
          {/if}
        </button>
      </div>

      <div class="flex flex-1 justify-center items-center">
        <div class="flex flex-shrink-0 items-center">
          <a href="/">
            <img
              src="images/bundesbattle-logo.svg"
              alt="BundesBattle Logo"
              class="w-auto h-8"
            />
          </a>
        </div>
      </div>
    </div>
  </div>

  {#if mobileMenuOpen}
    <!-- Mobile menu, show/hide based on menu state. -->
    <div class="lg:hidden" id="mobile-menu">
      <div class="px-2 pt-2 pb-3 space-y-1">
        <a
          href="/basel"
          class="block px-3 py-2 text-base font-medium rounded-md hover:bg-bbyellow hover:text-slate-800 aria-current:bg-bbyellow aria-current:text-slate-800"
          aria-current={$page.url.pathname === "/basel"}>Basel</a
        >
        <a
          href="/zurich"
          class="block px-3 py-2 text-base font-medium rounded-md hover:bg-bbyellow hover:text-slate-800 aria-current:bg-bbyellow aria-current:text-slate-800"
          aria-current={$page.url.pathname === "/zurich"}>Zürich</a
        >
        <a
          href="/direct-qualifiers"
          class="block px-3 py-2 text-base font-medium rounded-md hover:bg-bbyellow hover:text-slate-800 aria-current:bg-bbyellow aria-current:text-slate-800"
          aria-current={$page.url.pathname === "/direct-qualifiers"}
          >Direct Qualifiers</a
        >
        <a
          href="/finals"
          class="block px-3 py-2 text-base font-medium rounded-md hover:bg-bbyellow hover:text-slate-800 aria-current:bg-bbyellow aria-current:text-slate-800"
          aria-current={$page.url.pathname === "/finals"}>Finals</a
        >
      </div>
    </div>
  {/if}
</nav>

<main class="container flex-1 px-2 mx-auto mt-4 max-w-3xl">
  <slot />
</main>

<footer
  class="flex flex-col gap-5 justify-center items-center pt-8 pb-4 mt-4 text-sm shadow bg-neutral-900"
>
  <div class="flex flex-row gap-2 justify-center items-center">
    A project by <a href="https://hardread.ch" target="_blank"
      ><img
        src="images/hardread-logo.webp"
        alt="Hardread Logo"
        class="w-auto h-5"
      /></a
    >
    and <a href="https://fgcbasel.ch" class="text-bbyellow">FGC Basel</a>
  </div>
  <div>
    <a href="https://discord.gg/F4q7XqG" class="hover:text-bbyellow">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        class="w-8 h-8"
        ><path
          fill="currentColor"
          d="M19.27 5.33C17.94 4.71 16.5 4.26 15 4a.09.09 0 0 0-.07.03c-.18.33-.39.76-.53 1.09a16.09 16.09 0 0 0-4.8 0c-.14-.34-.35-.76-.54-1.09c-.01-.02-.04-.03-.07-.03c-1.5.26-2.93.71-4.27 1.33c-.01 0-.02.01-.03.02c-2.72 4.07-3.47 8.03-3.1 11.95c0 .02.01.04.03.05c1.8 1.32 3.53 2.12 5.24 2.65c.03.01.06 0 .07-.02c.4-.55.76-1.13 1.07-1.74c.02-.04 0-.08-.04-.09c-.57-.22-1.11-.48-1.64-.78c-.04-.02-.04-.08-.01-.11c.11-.08.22-.17.33-.25c.02-.02.05-.02.07-.01c3.44 1.57 7.15 1.57 10.55 0c.02-.01.05-.01.07.01c.11.09.22.17.33.26c.04.03.04.09-.01.11c-.52.31-1.07.56-1.64.78c-.04.01-.05.06-.04.09c.32.61.68 1.19 1.07 1.74c.03.01.06.02.09.01c1.72-.53 3.45-1.33 5.25-2.65c.02-.01.03-.03.03-.05c.44-4.53-.73-8.46-3.1-11.95c-.01-.01-.02-.02-.04-.02zM8.52 14.91c-1.03 0-1.89-.95-1.89-2.12s.84-2.12 1.89-2.12c1.06 0 1.9.96 1.89 2.12c0 1.17-.84 2.12-1.89 2.12zm6.97 0c-1.03 0-1.89-.95-1.89-2.12s.84-2.12 1.89-2.12c1.06 0 1.9.96 1.89 2.12c0 1.17-.83 2.12-1.89 2.12z"
        /></svg
      >
    </a>
  </div>
</footer>

<style lang="postcss">
  :global(body) {
    @apply flex flex-col min-h-screen;
  }
</style>
