#!/usr/bin/env python3
"""
EdgeUp App Background Generator
Creates elegant dark mode backgrounds with subtle textures
"""

from PIL import Image, ImageDraw, ImageFilter
import numpy as np
import random
import math

# Configuration
WIDTH = 1080
HEIGHT = 1920
OUTPUT_DIR = "backgrounds"

# Color palette: charcoal black → deep slate gray
COLOR_TOP = (28, 28, 32)      # Charcoal black
COLOR_BOTTOM = (55, 60, 68)   # Deep slate gray
COLOR_MID = (42, 44, 50)      # Mid-tone for smoother gradient

def create_premium_gradient(width, height):
    """Create a sophisticated multi-stop gradient"""
    img = Image.new('RGB', (width, height))
    draw = ImageDraw.Draw(img)

    # Create smooth gradient with multiple stops
    for y in range(height):
        # Use ease-in-out curve for smoother gradient
        progress = y / height
        # Cubic easing for premium feel
        eased = progress * progress * (3 - 2 * progress)

        # Interpolate through color stops
        if eased < 0.5:
            # Top half: COLOR_TOP → COLOR_MID
            t = eased * 2
            r = int(COLOR_TOP[0] + (COLOR_MID[0] - COLOR_TOP[0]) * t)
            g = int(COLOR_TOP[1] + (COLOR_MID[1] - COLOR_TOP[1]) * t)
            b = int(COLOR_TOP[2] + (COLOR_MID[2] - COLOR_TOP[2]) * t)
        else:
            # Bottom half: COLOR_MID → COLOR_BOTTOM
            t = (eased - 0.5) * 2
            r = int(COLOR_MID[0] + (COLOR_BOTTOM[0] - COLOR_MID[0]) * t)
            g = int(COLOR_MID[1] + (COLOR_BOTTOM[1] - COLOR_MID[1]) * t)
            b = int(COLOR_MID[2] + (COLOR_BOTTOM[2] - COLOR_MID[2]) * t)

        draw.line([(0, y), (width, y)], fill=(r, g, b))

    return img

def apply_vignette(img, intensity=0.4):
    """Apply gentle vignette effect - darker edges, brighter center"""
    width, height = img.size

    # Create vignette mask
    vignette = Image.new('L', (width, height), 0)
    vignette_draw = ImageDraw.Draw(vignette)

    # Create radial gradient for vignette
    center_x, center_y = width // 2, height // 2
    max_dist = math.sqrt(center_x**2 + center_y**2)

    for y in range(height):
        for x in range(width):
            # Calculate distance from center
            dist = math.sqrt((x - center_x)**2 + (y - center_y)**2)
            # Normalize and apply easing
            normalized = dist / max_dist
            # Softer vignette with cubic easing
            vignette_value = int(255 * (1 - (normalized ** 2) * intensity))
            vignette.putpixel((x, y), vignette_value)

    # Smooth the vignette
    vignette = vignette.filter(ImageFilter.GaussianBlur(radius=50))

    # Apply vignette to image
    img_array = np.array(img, dtype=np.float32)
    vignette_array = np.array(vignette, dtype=np.float32) / 255.0

    for c in range(3):
        img_array[:, :, c] *= vignette_array

    # Add slight brightness to center
    center_boost = np.zeros_like(vignette_array)
    for y in range(height):
        for x in range(width):
            dist = math.sqrt((x - center_x)**2 + (y - center_y)**2)
            normalized = dist / max_dist
            # Boost center brightness subtly
            center_boost[y, x] = (1 - normalized ** 3) * 8  # Very subtle boost

    for c in range(3):
        img_array[:, :, c] += center_boost

    img_array = np.clip(img_array, 0, 255).astype(np.uint8)
    return Image.fromarray(img_array)

def add_premium_grain(img, intensity=0.015):
    """Add subtle film grain for premium finish"""
    img_array = np.array(img, dtype=np.float32)

    # Generate fine grain noise
    noise = np.random.normal(0, intensity * 255, img_array.shape[:2])

    # Apply grain to all channels
    for c in range(3):
        img_array[:, :, c] += noise

    img_array = np.clip(img_array, 0, 255).astype(np.uint8)
    return Image.fromarray(img_array)

def add_geometric_mesh(img, intensity=0.08):
    """Add subtle geometric mesh pattern"""
    width, height = img.size
    overlay = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    # Create subtle geometric pattern
    cell_size = 120
    line_color = (255, 255, 255, int(255 * intensity * 0.5))  # Very subtle white lines

    # Draw diagonal lines creating diamond/mesh pattern
    for i in range(-height // cell_size, width // cell_size + height // cell_size):
        # Diagonal lines going down-right
        start_x = i * cell_size
        start_y = 0
        end_x = i * cell_size + height
        end_y = height
        draw.line([(start_x, start_y), (end_x, end_y)], fill=line_color, width=1)

    for i in range(-height // cell_size, width // cell_size + height // cell_size):
        # Diagonal lines going down-left
        start_x = i * cell_size
        start_y = 0
        end_x = i * cell_size - height
        end_y = height
        draw.line([(start_x, start_y), (end_x, end_y)], fill=line_color, width=1)

    # Apply blur for softness
    overlay = overlay.filter(ImageFilter.GaussianBlur(radius=1.5))

    # Composite with original
    img = img.convert('RGBA')
    img = Image.alpha_composite(img, overlay)
    return img.convert('RGB')

def add_lowpoly_texture(img, intensity=0.06):
    """Add subtle low-poly/crystalline texture"""
    width, height = img.size
    overlay = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    # Create random points for low-poly effect
    num_shapes = 40  # Sparse for subtlety

    for _ in range(num_shapes):
        # Random triangle
        points = [
            (random.randint(0, width), random.randint(0, height)),
            (random.randint(0, width), random.randint(0, height)),
            (random.randint(0, width), random.randint(0, height))
        ]

        # Very subtle white or light gray
        brightness = random.randint(200, 255)
        alpha = int(255 * intensity * random.uniform(0.3, 0.7))
        color = (brightness, brightness, brightness, alpha)

        draw.polygon(points, fill=color)

    # Heavy blur for subtle effect
    overlay = overlay.filter(ImageFilter.GaussianBlur(radius=80))

    # Composite
    img = img.convert('RGBA')
    img = Image.alpha_composite(img, overlay)
    return img.convert('RGB')

def generate_variation_1():
    """Variation 1: Pure elegant gradient + vignette"""
    print("Generating Variation 1: Pure Gradient + Vignette...")
    img = create_premium_gradient(WIDTH, HEIGHT)
    img = apply_vignette(img, intensity=0.35)
    return img

def generate_variation_2():
    """Variation 2: Gradient + subtle geometric texture"""
    print("Generating Variation 2: Gradient + Geometric Mesh...")
    img = create_premium_gradient(WIDTH, HEIGHT)
    img = apply_vignette(img, intensity=0.35)
    img = add_geometric_mesh(img, intensity=0.08)
    # Add slight grain for extra premium feel
    img = add_premium_grain(img, intensity=0.01)
    return img

def generate_variation_3():
    """Variation 3: Gradient + premium grain/noise finish"""
    print("Generating Variation 3: Gradient + Premium Grain...")
    img = create_premium_gradient(WIDTH, HEIGHT)
    img = apply_vignette(img, intensity=0.35)
    img = add_premium_grain(img, intensity=0.018)
    return img

def generate_bonus_variation():
    """Bonus: Gradient + low-poly crystalline texture"""
    print("Generating Bonus Variation: Gradient + Low-Poly Texture...")
    img = create_premium_gradient(WIDTH, HEIGHT)
    img = apply_vignette(img, intensity=0.35)
    img = add_lowpoly_texture(img, intensity=0.06)
    img = add_premium_grain(img, intensity=0.008)
    return img

def main():
    import os

    # Create output directory
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    print("EdgeUp Background Generator")
    print(f"Resolution: {WIDTH}x{HEIGHT}")
    print(f"Output directory: {OUTPUT_DIR}/")
    print("-" * 50)

    # Generate all variations
    variations = [
        ("edgeup_bg_v1_pure_gradient.png", generate_variation_1()),
        ("edgeup_bg_v2_geometric.png", generate_variation_2()),
        ("edgeup_bg_v3_grain.png", generate_variation_3()),
        ("edgeup_bg_bonus_lowpoly.png", generate_bonus_variation()),
    ]

    # Save all images
    for filename, img in variations:
        filepath = os.path.join(OUTPUT_DIR, filename)
        img.save(filepath, quality=95, optimize=True)
        print(f"✓ Saved: {filepath}")

    print("-" * 50)
    print("✓ All backgrounds generated successfully!")
    print(f"\nFind your backgrounds in: {OUTPUT_DIR}/")
    print("\nTips:")
    print("- All backgrounds are UI-friendly with good contrast")
    print("- White and pastel text will be readable on top")
    print("- Use v1 for minimal distraction")
    print("- Use v2 for subtle modern feel")
    print("- Use v3 for premium film-like quality")
    print("- Bonus low-poly adds sophisticated depth")

if __name__ == "__main__":
    main()
