"use client";

import React from "react";

type ButtonVariant = "primary" | "secondary" | "ghost" | "cyber";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  fullWidth?: boolean;
}

const baseStyles =
  "relative flex items-center justify-center gap-2 font-medium uppercase tracking-wider transition-all duration-200 active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed outline-none focus:ring-2 focus:ring-donut-500/50 focus:ring-offset-2 focus:ring-offset-corp-950";

const variantStyles: Record<ButtonVariant, string> = {
  primary:
    "bg-donut-500 text-white hover:bg-donut-600 shadow-lg shadow-donut-500/25 hover:shadow-donut-500/40 border border-transparent rounded-lg",
  secondary:
    "bg-corp-800 border border-corp-700 text-corp-200 hover:border-donut-500/40 hover:text-corp-50 rounded-lg hover:shadow-[0_0_10px_rgba(236,72,153,0.1)]",
  ghost:
    "bg-transparent text-corp-400 hover:text-corp-50 hover:bg-corp-800 rounded-lg",
  cyber:
    "bg-corp-900 border border-donut-500/50 text-donut-400 hover:bg-donut-500 hover:text-white rounded-lg shadow-[0_0_10px_rgba(236,72,153,0.15)] hover:shadow-[0_0_20px_rgba(236,72,153,0.4)]",
};

export function Button({
  children,
  variant = "primary",
  fullWidth = false,
  className = "",
  disabled,
  ...props
}: ButtonProps) {
  const widthClass = fullWidth ? "w-full py-3.5 text-base" : "px-4 py-2 text-sm";

  return (
    <button
      className={`${baseStyles} ${variantStyles[variant]} ${widthClass} ${className}`}
      disabled={disabled}
      {...props}
    >
      {children}
    </button>
  );
}
