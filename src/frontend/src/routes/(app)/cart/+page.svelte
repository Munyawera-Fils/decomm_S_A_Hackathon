<script lang="ts">
  import { cart, cartPage, fullName } from "$lib/data/stores/stores";
  import { Button } from "$lib/components/ui/button/index.js";
  import { toast } from "svelte-sonner";
  import Reload from "svelte-radix/Reload.svelte";
  import { goto } from "$app/navigation";
  import { actorBackend } from "$lib/motokoImports/backend";
  // import { actorNFT } from "$lib/motokoImports/nft";
  import { onMount } from "svelte";
  import { AuthClient } from "@dfinity/auth-client"; // Import the AuthClient
  import { Principal } from "@dfinity/principal";

  let checkout = false;
  let buttonClicked = false;
  let posts = false;
  let converted: any[] = [];
  let formSubmitted = false;
  let formCleared = false;
  let totalCost = 0;
  let isAuthenticated = false; // Track authentication status
  let authClient: AuthClient | null = null; // Initialize auth client

  $: {
    if (converted.length > 0) {
      totalCost = total();
    }
  }

  // Initialize auth client on mount
  onMount(async () => {
    authClient = await AuthClient.create();
    const isAuthenticatedResult = await authClient.isAuthenticated();
    isAuthenticated = isAuthenticatedResult;
    
    if (isAuthenticated) {
      // Load user data if authenticated
      const resProduct = await actorBackend.getUserCartProductTypes($fullName);
      converted = await convertBigIntToNumber(resProduct);
      posts = true;
    }
  });

  async function loginICPWallet() {
  try {
    if (!authClient) {
      throw new Error("Auth client not initialized");
    }
    await authClient.login({
      onSuccess: async () => {
        isAuthenticated = true;
        toast("Successfully connected to ICP Wallet");
        // Add a redirect to NNS account if needed
        window.location.href = "https://nns.ic0.app"; // Replace with the actual NNS URL if different
      },
      onError: (error) => {
        toast.error("Failed to connect to ICP Wallet: " + error.message);
      }
    });
  } catch (error) {
    toast.error("An error occurred while logging in: " + error.message);
  }
}


  async function payWithICPWallet() {
    try {
      if (!isAuthenticated) {
        await loginICPWallet(); // Prompt user to log in if not authenticated
      }
      
      // Assuming you have a function to process payment
      const paymentResult = await processICPWalletPayment(totalCost);
      if (paymentResult) {
        toast("Payment successful with ICP Wallet");
        await removeAllProducts();
        checkout = false;
        $cartPage.value = false;
      } else {
        toast.error("Payment failed. Please try again.");
      }
    } catch (error) {
      toast.error("An error occurred during payment: " + error.message);
    }
  }

  async function processICPWalletPayment(amount: number) {
    // I will Implement  payment logic here
    
    return true; // Return payment result (true/false)
  }

  async function payWithNFTWallet() {
  try {
    // Assuming you have a function to process NFT payment
    const nftPaymentResult = await processNFTWalletPayment(totalCost);
    if (nftPaymentResult) {
      toast("Payment successful with NFT Wallet");
      await removeAllProducts();
      checkout = false;
      $cartPage.value = false;
      window.location.reload();
    } else {
      toast.error("Payment failed. Please try again.");
    }
  } catch (error) {
    toast.error("An error occurred during NFT payment: ");
  }
}

async function processNFTWalletPayment(amount: number) {
  
  try {
      for (const product of converted) {
        try {
          buttonClicked = true;
          const result = await actorBackend.payWithNFT(
            $fullName,
            product.productID,
          );
          buttonClicked = false;
          if ("err" in result) {
            throw new Error(result.err);
          }
          return true;
        } catch (error) {
          console.error("Error in NFT Payment:", error);
          throw error;
        }
      }
    } catch (error) {
      console.error("Error in purchase function:", error);
      buttonClicked = false;
      toast.error(
        "There was an error purchasing all the products. Please try again: "+error,
      );
    }
  return false; // Return payment result (true/false)
}


  async function removeProduct(product) {
    try {
      formSubmitted = true;
      const result = await actorBackend.removeFromUserCart(
        $fullName,
        product.productID,
      );
      if (result) {
        toast("Removed " + product.name + " from cart");
        $cart.value = $cart.value - 1;
        converted = converted.filter((p) => p.productID !== product.productID);
      } else {
        toast.error("Failed to remove product from cart");
      }
    } catch (error) {
      toast.error("There was an error removing the product. Please try again", {
        description: getFormattedDateTime(),
      });
    } finally {
      formSubmitted = false;
    }
  }

  async function removeAllProducts() {
    try {
      formCleared = true;
      const result = await actorBackend.clearUserCart($fullName);
      if (result) {
        toast("Removed all products from cart");
        $cart.value = 0;
        converted = [];
      } else {
        toast.error("Failed to clear the cart");
      }
    } catch (error) {
      toast.error(
        "There was an error removing all the products. Please try again",
        { description: getFormattedDateTime() },
      );
    } finally {
      formCleared = false;
    }
  }

  function total() {
    let totalPrice = 0;

    if (converted.length === 0) {
      return totalPrice;
    }
    converted.forEach((product) => {
      if (!product.productPrice || !product.productPrice.currency) {
        return;
      }

      Object.keys(product.productPrice.currency).forEach((currency) => {
        if (product.productPrice.currency.hasOwnProperty(currency)) {
          totalPrice += product.productPrice.amount;
        } else {
          toast.error("Currency not found in product. Please try again", {
            description: getFormattedDateTime(),
          });
        }
      });
    });

    return totalPrice;
  }

  async function purchase() {
    try {
      for (const product of converted) {
        try {
          buttonClicked = true;
          const result = await actorBackend.purchase(
            $fullName,
            product.productID,
          );
          buttonClicked = false;
          if ("err" in result) {
            throw new Error(result.err);
          }
        } catch (error) {
          console.error("Error in purchase:", error);
          throw error;
        }
      }
      await removeAllProducts();
      checkout = false;
      $cartPage.value = false;
      toast("Items Purchased", { description: getFormattedDateTime() });
    } catch (error) {
      console.error("Error in purchase function:", error);
      buttonClicked = false;
      toast.error(
        "There was an error purchasing all the products. Please try again: " +
          error.message,
      );
    }
  }

  async function homePage() {
    await goto("/");
  }

  onMount(async () => {
    const resProduct = await actorBackend.getUserCartProductTypes($fullName);
    converted = await convertBigIntToNumber(resProduct);
    posts = true;
  });

  async function convertBigIntToNumber(products: any[]) {
    return products.map((product) => ({
      ...product,
      productPrice: {
        ...product.productPrice,
        amount: Number(product.productPrice.amount),
      },
      productID: Number(product.productID),
    }));
  }

  function getFormattedDateTime() {
    const now = new Date();
    const dayOfWeek = now.toLocaleDateString("en-US", { weekday: "long" });
    const monthDay = now.toLocaleDateString("en-US", {
      month: "long",
      day: "numeric",
    });
    const year = now.getFullYear();
    const time = now.toLocaleTimeString([], {
      hour: "numeric",
      minute: "2-digit",
      hour12: true,
    });

    return `${dayOfWeek}, ${monthDay} ${year} at ${time}`;
  }
</script>

{#if !checkout}
  <div class="flex flex-col min-h-screen w-full mt-32 lg:mt-40 p-2 bg-zinc-50">
    <div class="col-span-12 grid grid-cols-12 px-2 lg:px-10 flex-none">
      <div class="col-span-12 mb-5">
        <a href="/" class="flex" on:click|preventDefault={() => homePage()}>
          <svg
            class="arrow-icon"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
          >
            <path
              d="M20 11H7.414l4.293-4.293a1 1 0 0 0-1.414-1.414l-6 6a1 1 0 0 0 0 1.414l6 6a1 1 0 0 0 1.414-1.414L7.414 13H20a1 1 0 0 0 0-2z"
            />
          </svg>
          Go Back
        </a>
      </div>
      <div
        class="col-span-12 mb-10 flex flex-col lg:flex-row lg:items-center justify-between"
      >
        <h1 class="text-3xl font-semibold mb-5 lg:mb-0">Shopping Cart</h1>
        <div
          class="col-span-12 lg:col-span-auto flex flex-col lg:flex-row lg:gap-x-2"
        >
          {#if !formCleared}
            <Button
              variant="destructive"
              class="mb-2 lg:mb-0"
              on:click={() => removeAllProducts()}>Clear Cart</Button
            >
          {:else}
            <Button class="mb-2 lg:mb-0" disabled>
              <Reload class="flex justify-center h-4/5 animate-spin" />
              Clearing Cart
            </Button>
          {/if}
          <Button on:click={() => (checkout = true)}>Proceed to Checkout</Button
          >
        </div>
      </div>
      <div
        class="col-span-12 grid grid-cols-12 {!posts
          ? 'justify-center items-center w-full'
          : ''}"
      >
        {#if !posts}
          <div
            class="col-span-12 flex h-full w-full justify-center items-center text-3xl lg:text-7xl font-medium mt-40 2xl:mt-52 animate-pulse-custom"
          >
            Loading Cart Items....
          </div>
        {:else if posts && converted.length >= 1}
          {#each converted as product}
            <div
              class="col-span-4 lg:col-span-2 lg:ml-5 mb-12 border-y-[3.5px] border-l-[3.5px] border-zinc-400 rounded-tl-lg rounded-bl-lg"
            >
              <img
                class="h-52 w-52 object-cover p-2"
                src={product.productPicture}
                alt={product.name}
              />
            </div>
            <div
              class="col-span-8 lg:col-span-10 border-y-[3.5px] border-r-[3.5px] border-gray-400 h-[13.4rem] w-full rounded-tr-lg rounded-br-lg"
            >
              <div class="block relative">
                <p class="text-2xl font-semibold mt-12">{product.name}</p>
                <p class="opacity-75">{product.productCategory}</p>
                {#each Object.keys(product.productPrice.currency) as currency}
                  {#if product.productPrice.currency.hasOwnProperty(currency)}
                    {product.productPrice.amount} {currency.toUpperCase()}
                  {/if}
                {/each}
                {#if !product.isSold}
                  <p class="text-green-500">In stock</p>
                {:else}
                  <p class="text-red-500">Out of Stock</p>
                {/if}
                {#if !formSubmitted}
                  <Button
                    variant="destructive"
                    class="mt-2 absolute right-2"
                    on:click={() => removeProduct(product)}
                    >Remove Product</Button
                  >
                {:else}
                  <Button class="mt-2 absolute right-2" disabled>
                    <Reload class="flex justify-center h-4/5 animate-spin" />
                    Removing from Cart
                  </Button>
                {/if}
              </div>
            </div>
          {/each}
        {:else if posts && converted.length <= 0}
          <div
            class="col-span-12 flex h-full w-full justify-center items-center text-3xl lg:text-7xl font-medium mt-40 2xl:mt-52"
          >
            No Products Found In Cart....
          </div>
        {/if}
      </div>
    </div>
  </div>
{:else if checkout}
  <div class="grid grid-cols-12 w-full mt-32 lg:mt-40 p-2">
    <div class="col-span-12 grid grid-cols-12 px-2 lg:px-10">
      <div class="col-span-12 mb-5">
        <a
          href="/"
          class="flex"
          on:click|preventDefault={() => (checkout = false)}
        >
          <svg
            class="arrow-icon"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
          >
            <path
              d="M20 11H7.414l4.293-4.293a1 1 0 0 0-1.414-1.414l-6 6a1 1 0 0 0 0 1.414l6 6a1 1 0 0 0 1.414-1.414L7.414 13H20a1 1 0 0 0 0-2z"
            />
          </svg>
          Go Back
        </a>
      </div>
      <div class="col-span-12 mb-10">
        <h1 class="text-3xl font-semibold mb-5 lg:mb-0">Checkout</h1>

        <!-- Banner Section -->
    <div class="w-full h-24 bg-blue-500 flex items-center justify-center">
      <h2 class="text-white text-xl font-bold">Your Advertisement banner Here</h2>
    </div>
      </div>
      <div
        class="grid grid-cols-12 col-span-12 justify-center items-center border-[3px] border-gray-600 p-4"
      >
        {#each converted as product}
          <div class="col-span-12 my-2">
            <img src={product.productPicture} alt={product.name} class="product-image" style="widht:100px; height:100px;" />
            {product.name}:
            {#each Object.keys(product.productPrice.currency) as currency}
              {#if product.productPrice.currency.hasOwnProperty(currency)}
                {product.productPrice.amount} {currency.toUpperCase()}
              {/if}
            {/each}
          </div>
        {/each}
        <div class="col-span-12 my-2">
          Total Price of all products are <span class="font-bold"
            >{totalCost}</span
          > 
        </div>



        
        <div
          class="col-span-12 my-2 flex items-end justify-end place-items-end"
        >
          {#if !buttonClicked}
         
          <!-- <Button class="icp-wallet-button" style="background-color: #00A3FF;" on:click={() => payWithICPWallet()}>Connect and Pay with ICP Wallet</Button> -->
          <Button class="nft-wallet-button" style=" background-color: #ff4f00;"  on:click={payWithNFTWallet}>Pay with NFT Wallet</Button>
            <!-- <Button on:click={() => purchase()}>Purchase</Button> -->
          {:else}
            <Button disabled>
              <Reload class="mr-2 h-4 w-4 animate-spin" />
              {#if converted.length > 1}
                Purchasing Products
              {:else}
                Purchasing Product
              {/if}
            </Button>
          {/if}
        </div>
      </div>
    </div>
  </div>
{/if}

<style>
  .arrow-icon {
    width: 20px;
    height: 20px;
    margin-right: 5px;
  }

  .icp-wallet-button {
    background-color: #1F7F92; /* Internet Computer brand color */
    color: #FFFFFF; /* White text */
    border: 2px solid #1F7F92; /* Border color */
    border-radius: 8px; /* Rounded corners */
    padding: 12px 24px; /* Padding for the button */
    font-size: 16px; /* Font size */
    font-weight: bold; /* Bold text */
    cursor: pointer; /* Pointer cursor on hover */
    transition: background-color 0.3s, border-color 0.3s; /* Smooth transition */
  }

  .icp-wallet-button:hover {
    background-color: #146A7A; /* Darker shade on hover */
    border-color: #146A7A; /* Darker shade on hover */
  }

  .icp-wallet-button:disabled {
    background-color: #B0BEC5; /* Light gray for disabled */
    border-color: #B0BEC5; /* Light gray for disabled */
    cursor: not-allowed; /* Not-allowed cursor */
  }

  .button-icp {
  background-color: #00a3ff; /* Example color for ICP Wallet */
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.button-icp:hover {
  background-color: #007bbd; /* Darker shade for hover effect */
}

.button-nft {
  background-color: #ff4f00; /* Example color for NFT Wallet */
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.button-nft:hover {
  background-color: #cc3e00; /* Darker shade for hover effect */
}

</style>

