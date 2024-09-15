<script lang="ts">
  import { Button } from "$lib/components/ui/button";
  import ViewProducts from "$lib/components/modules/admin/ViewProducts/ViewProducts.svelte";
  import AddProduct from "$lib/components/modules/admin/AddProduct/AddProduct.svelte";
  import AddWalletAddress from "$lib/components/modules/admin/AddWalletAddress/AddWalletAddress.svelte";
  import DisplayWalletAddresses from "$lib/components/modules/admin/DisplayWalletAddresses.svelte";
  import AddCurrency from "$lib/components/modules/admin/AddCurrency/AddCurrency.svelte"; // Import the new component
  import DisplayCurrencies from "$lib/components/modules/admin/DisplayCurrencies/DisplayCurrencies.svelte"; // Import the new component
  import { fullName } from "$lib/data/stores/stores";

  let chosen = "Add Products";
</script>

<div class="grid grid-cols-12 p-4 mt-24 xl:m-20 xl:p-20 xl:border-4 xl:border-zinc-400 xl:border-solid xl:shadow-2xl max-h-fit"
>
  <div class="col-span-12 h-fit grid grid-cols-12 w-full overflow-scroll mt-5">
    <div class="col-span-12">
      <h1 class="text-2xl font-bold">Welcome {$fullName}!</h1>
      <p class="text-lg border-b-2 border-zinc-300 pb-5 mt-2 opacity-75">
        Manage your products and preferences here.
      </p>
    </div>
    <div class="col-span-12 grid grid-cols-12">
      <div class="col-span-12 lg:hidden flex px-2 justify-around mt-5">
        <div>
          <Button
            class="w-full my-1 justify-start hover:underline {chosen ===
            'Add Products'
              ? 'bg-stone-100'
              : ''}"
            variant="ghost"
            on:click={() => (chosen = "Add Products")}>Add Products</Button
          >
        </div>
        <div>
          <Button
            class="w-full my-1 justify-start hover:underline {chosen ===
            'View Products'
              ? 'bg-stone-100'
              : ''}"
            variant="ghost"
            on:click={() => (chosen = "View Products")}>View Products</Button
          >
        </div>
        <div>
          <Button
            class="w-full my-1 justify-start hover:underline {chosen ===
            'Add Wallet Address'
              ? 'bg-stone-100'
              : ''}"
            variant="ghost"
            on:click={() => (chosen = "Add Wallet Address")}>Add Wallet Address</Button
          >
        </div>
        <div>
          <Button
            class="w-full my-1 justify-start hover:underline {chosen ===
            'Display Wallet Addresses'
              ? 'bg-stone-100'
              : ''}"
            variant="ghost"
            on:click={() => (chosen = "Display Wallet Addresses")}>Display Wallet Addresses</Button
          >
        </div>
        <div>
          <Button
            class="w-full my-1 justify-start hover:underline {chosen ===
            'Add Currency'
              ? 'bg-stone-100'
              : ''}"
            variant="ghost"
            on:click={() => (chosen = "Add Currency")}>Add Currency</Button
          >
        </div>
        <div>
          <Button
            class="w-full my-1 justify-start hover:underline {chosen ===
            'Display Currencies'
              ? 'bg-stone-100'
              : ''}"
            variant="ghost"
            on:click={() => (chosen = "Display Currencies")}>Display Currencies</Button
          >
        </div>
      </div>
      <div class="hidden lg:col-span-2 lg:block mt-10">
        <div>
          <Button
            class="w-full my-1 justify-start hover:underline {chosen ===
            'Add Products'
              ? 'bg-stone-100'
              : ''}"
            variant="ghost"
            on:click={() => (chosen = "Add Products")}>Add Products</Button
          >
        </div>
        <div>
          <Button
            class="w-full my-1 justify-start hover:underline {chosen ===
            'View Products'
              ? 'bg-stone-100'
              : ''}"
            variant="ghost"
            on:click={() => (chosen = "View Products")}>View Products</Button
          >
        </div>
        <div>
          <Button
            class="w-full my-1 justify-start hover:underline {chosen ===
            'Add Wallet Address'
              ? 'bg-stone-100'
              : ''}"
            variant="ghost"
            on:click={() => (chosen = "Add Wallet Address")}>Add Wallet Address</Button
          >
        </div>
        <div>
          <Button
            class="w-full my-1 justify-start hover:underline {chosen ===
            'Display Wallet Addresses'
              ? 'bg-stone-100'
              : ''}"
            variant="ghost"
            on:click={() => (chosen = "Display Wallet Addresses")}>Display Wallet Addresses</Button
          >
        </div>
        <div>
          <Button
            class="w-full my-1 justify-start hover:underline {chosen ===
            'Add Currency'
              ? 'bg-stone-100'
              : ''}"
            variant="ghost"
            on:click={() => (chosen = "Add Currency")}>Add Currency</Button
          >
        </div>
        <div>
          <Button
            class="w-full my-1 justify-start hover:underline {chosen ===
            'Display Currencies'
              ? 'bg-stone-100'
              : ''}"
            variant="ghost"
            on:click={() => (chosen = "Display Currencies")}>Display Currencies</Button
          >
        </div>
      </div>
      <div
        class="col-span-12 lg:col-span-10 mt-10 px-2 h-fit overflow-scroll lg:pl-10"
      >
        {#if chosen === "Add Products"}
          <AddProduct />
        {:else if chosen === "View Products"}
          <ViewProducts />
        {:else if chosen === "Add Wallet Address"}
          <AddWalletAddress />
        {:else if chosen === "Display Wallet Addresses"}
          <DisplayWalletAddresses />
        {:else if chosen === "Add Currency"}
          <AddCurrency />
        {:else if chosen === "Display Currencies"}
          <DisplayCurrencies />
        {/if}
      </div>
    </div>
  </div>
</div>
