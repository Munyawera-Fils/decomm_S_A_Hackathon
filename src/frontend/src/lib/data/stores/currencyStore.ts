import { writable } from "svelte/store";

// Initialize with an empty array of currencies
export const allowedCurrencies = writable<string[]>([]);
