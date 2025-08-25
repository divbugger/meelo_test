#!/usr/bin/env python3
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch, ConnectionPatch
import numpy as np

# Set up the figure
fig, ax = plt.subplots(1, 1, figsize=(16, 12))
ax.set_xlim(0, 10)
ax.set_ylim(0, 10)
ax.axis('off')

# Define colors
flutter_color = '#02569B'
supabase_color = '#3ECF8E'
ai_color = '#FF6B35'
storage_color = '#6C63FF'
auth_color = '#FF4757'

# Title
ax.text(5, 9.5, 'Meelo Flutter App - System Architecture', 
        fontsize=20, fontweight='bold', ha='center')

# Flutter Mobile App Layer
flutter_box = FancyBboxPatch((0.5, 7), 9, 1.5, boxstyle="round,pad=0.05", 
                            facecolor=flutter_color, edgecolor='black', alpha=0.8)
ax.add_patch(flutter_box)
ax.text(5, 7.75, 'Flutter Mobile Application', fontsize=14, fontweight='bold', 
        ha='center', va='center', color='white')

# UI Screens
screens = ['Auth Screens', 'Home Dashboard', 'Memories', 'Profile', 'Questionnaire', 'Figures']
screen_width = 1.4
start_x = 0.8
for i, screen in enumerate(screens):
    screen_box = FancyBboxPatch((start_x + i * screen_width, 6.2), screen_width-0.1, 0.6, 
                               boxstyle="round,pad=0.02", facecolor='white', 
                               edgecolor=flutter_color, alpha=0.9)
    ax.add_patch(screen_box)
    ax.text(start_x + i * screen_width + (screen_width-0.1)/2, 6.5, screen, 
           fontsize=8, ha='center', va='center', fontweight='bold')

# Service Layer
service_box = FancyBboxPatch((0.5, 4.5), 9, 1.2, boxstyle="round,pad=0.05", 
                            facecolor='#E8F4FD', edgecolor='black', alpha=0.9)
ax.add_patch(service_box)
ax.text(5, 5.4, 'Service Layer', fontsize=14, fontweight='bold', ha='center', va='center')

# Individual Services
services = [
    ('AuthService', 1.2, auth_color),
    ('StoryService', 2.6, flutter_color),
    ('LanguageService', 4.0, '#9B59B6'),
    ('MistralService', 5.4, ai_color),
    ('ElevenLabsService', 6.8, ai_color),
    ('UserPrefsService', 8.2, '#2ECC71')
]

for service, x_pos, color in services:
    service_rect = FancyBboxPatch((x_pos, 4.7), 1.2, 0.7, boxstyle="round,pad=0.02", 
                                 facecolor=color, edgecolor='black', alpha=0.8)
    ax.add_patch(service_rect)
    ax.text(x_pos + 0.6, 5.05, service, fontsize=8, ha='center', va='center', 
           color='white', fontweight='bold')

# Backend Services Layer
backend_y = 2.5
backend_height = 1.5

# Supabase Backend
supabase_box = FancyBboxPatch((0.5, backend_y), 3.5, backend_height, 
                             boxstyle="round,pad=0.05", facecolor=supabase_color, 
                             edgecolor='black', alpha=0.8)
ax.add_patch(supabase_box)
ax.text(2.25, backend_y + backend_height - 0.3, 'Supabase Backend', 
        fontsize=12, fontweight='bold', ha='center', va='center', color='white')

# Supabase components
supabase_components = ['Authentication', 'PostgreSQL DB', 'Storage', 'Real-time']
comp_width = 0.8
for i, comp in enumerate(supabase_components):
    comp_x = 0.7 + i * comp_width
    comp_box = FancyBboxPatch((comp_x, backend_y + 0.2), comp_width-0.05, 0.5, 
                             boxstyle="round,pad=0.02", facecolor='white', 
                             edgecolor=supabase_color, alpha=0.9)
    ax.add_patch(comp_box)
    ax.text(comp_x + (comp_width-0.05)/2, backend_y + 0.45, comp, 
           fontsize=7, ha='center', va='center', fontweight='bold')

# External AI Services
# Mistral AI
mistral_box = FancyBboxPatch((4.5, backend_y), 2, backend_height/2 - 0.1, 
                            boxstyle="round,pad=0.05", facecolor=ai_color, 
                            edgecolor='black', alpha=0.8)
ax.add_patch(mistral_box)
ax.text(5.5, backend_y + 0.25, 'Mistral AI API', fontsize=10, fontweight='bold', 
        ha='center', va='center', color='white')
ax.text(5.5, backend_y + 0.05, 'Story Generation', fontsize=8, ha='center', va='center', color='white')

# ElevenLabs
eleven_box = FancyBboxPatch((4.5, backend_y + backend_height/2 + 0.1), 2, backend_height/2 - 0.1, 
                           boxstyle="round,pad=0.05", facecolor=ai_color, 
                           edgecolor='black', alpha=0.8)
ax.add_patch(eleven_box)
ax.text(5.5, backend_y + backend_height/2 + 0.35, 'ElevenLabs API', 
        fontsize=10, fontweight='bold', ha='center', va='center', color='white')
ax.text(5.5, backend_y + backend_height/2 + 0.15, 'Text-to-Speech', 
        fontsize=8, ha='center', va='center', color='white')

# Local Storage
storage_box = FancyBboxPatch((7, backend_y), 2.5, backend_height, 
                            boxstyle="round,pad=0.05", facecolor=storage_color, 
                            edgecolor='black', alpha=0.8)
ax.add_patch(storage_box)
ax.text(8.25, backend_y + backend_height - 0.3, 'Local Storage', 
        fontsize=12, fontweight='bold', ha='center', va='center', color='white')

# Local storage components
local_components = ['SharedPreferences', 'Language Settings', 'User Preferences']
for i, comp in enumerate(local_components):
    comp_y = backend_y + 0.2 + i * 0.3
    comp_box = FancyBboxPatch((7.2, comp_y), 2.1, 0.25, boxstyle="round,pad=0.02", 
                             facecolor='white', edgecolor=storage_color, alpha=0.9)
    ax.add_patch(comp_box)
    ax.text(8.25, comp_y + 0.125, comp, fontsize=7, ha='center', va='center', fontweight='bold')

# Data Flow Layer
data_y = 0.8
data_height = 1.2

# Database Tables
db_box = FancyBboxPatch((0.5, data_y), 4.5, data_height, boxstyle="round,pad=0.05", 
                       facecolor='#34495E', edgecolor='black', alpha=0.8)
ax.add_patch(db_box)
ax.text(2.75, data_y + data_height - 0.2, 'Database Schema (Supabase)', 
        fontsize=12, fontweight='bold', ha='center', va='center', color='white')

# Database tables
tables = [
    ('profiles', 'User profiles, settings,\nauthentication data'),
    ('stories', 'AI-generated stories,\naudio URLs, metadata')
]

for i, (table, desc) in enumerate(tables):
    table_x = 0.8 + i * 2.1
    table_box = FancyBboxPatch((table_x, data_y + 0.2), 1.8, 0.8, boxstyle="round,pad=0.02", 
                              facecolor='white', edgecolor='#34495E', alpha=0.9)
    ax.add_patch(table_box)
    ax.text(table_x + 0.9, data_y + 0.8, table, fontsize=9, ha='center', va='center', fontweight='bold')
    ax.text(table_x + 0.9, data_y + 0.45, desc, fontsize=7, ha='center', va='center')

# File Storage
file_box = FancyBboxPatch((5.5, data_y), 4, data_height, boxstyle="round,pad=0.05", 
                         facecolor='#16A085', edgecolor='black', alpha=0.8)
ax.add_patch(file_box)
ax.text(7.5, data_y + data_height - 0.2, 'File Storage (Supabase Storage)', 
        fontsize=12, fontweight='bold', ha='center', va='center', color='white')

# Storage buckets
bucket_box = FancyBboxPatch((5.8, data_y + 0.2), 3.4, 0.8, boxstyle="round,pad=0.02", 
                           facecolor='white', edgecolor='#16A085', alpha=0.9)
ax.add_patch(bucket_box)
ax.text(7.5, data_y + 0.8, 'story_audio', fontsize=9, ha='center', va='center', fontweight='bold')
ax.text(7.5, data_y + 0.45, 'MP3 audio files generated\nby ElevenLabs TTS', 
        fontsize=7, ha='center', va='center')

# Draw connection arrows
connections = [
    # Flutter to Services
    ((5, 7), (5, 5.7)),
    # Services to Backends
    ((1.8, 4.7), (2.25, 4)),  # Auth to Supabase
    ((3.2, 4.7), (2.25, 4)),  # Story to Supabase
    ((6, 4.7), (5.5, 4)),     # Mistral Service to API
    ((7.4, 4.7), (5.5, 3.5)), # ElevenLabs Service to API
    ((8.8, 4.7), (8.25, 4)),  # UserPrefs to Local Storage
    # Supabase to Database
    ((2.25, 2.5), (2.75, 2)),
    # Supabase to File Storage
    ((4, 3.25), (5.5, 1.5)),
]

for start, end in connections:
    arrow = ConnectionPatch(start, end, "data", "data", 
                           arrowstyle="->", shrinkA=0, shrinkB=0, 
                           mutation_scale=15, fc="black", alpha=0.7)
    ax.add_patch(arrow)

# Add protocol labels
protocols = [
    ('HTTPS/REST API', 5.5, 4.3),
    ('WebSocket\n(Real-time)', 3.5, 3.7),
    ('HTTP/JSON', 6.7, 4.3),
    ('Local I/O', 8.8, 3.7),
]

for protocol, x, y in protocols:
    ax.text(x, y, protocol, fontsize=7, ha='center', va='center', 
           bbox=dict(boxstyle="round,pad=0.3", facecolor='yellow', alpha=0.7))

# Add legend
legend_elements = [
    patches.Rectangle((0, 0), 1, 1, facecolor=flutter_color, alpha=0.8, label='Flutter Layer'),
    patches.Rectangle((0, 0), 1, 1, facecolor=supabase_color, alpha=0.8, label='Supabase Backend'),
    patches.Rectangle((0, 0), 1, 1, facecolor=ai_color, alpha=0.8, label='External AI APIs'),
    patches.Rectangle((0, 0), 1, 1, facecolor=storage_color, alpha=0.8, label='Local Storage'),
    patches.Rectangle((0, 0), 1, 1, facecolor='#34495E', alpha=0.8, label='Database'),
    patches.Rectangle((0, 0), 1, 1, facecolor='#16A085', alpha=0.8, label='File Storage'),
]

ax.legend(handles=legend_elements, loc='upper left', bbox_to_anchor=(0, 0.95), fontsize=8)

# Add flow description
flow_text = """
Key Data Flows:
1. User authentication via Supabase Auth
2. Story creation: User input → Mistral AI → Generated story → ElevenLabs → Audio file
3. Real-time story synchronization across app instances
4. Language preferences stored locally and synced with profile
5. Audio files stored in Supabase Storage buckets
"""

ax.text(0.2, 0.5, flow_text, fontsize=8, va='top', 
        bbox=dict(boxstyle="round,pad=0.5", facecolor='lightgray', alpha=0.9))

plt.tight_layout()
plt.savefig('D:/Idememory/test_code/meelo_test/high_level_arch/meelo_system_architecture.png', 
            dpi=300, bbox_inches='tight', facecolor='white')
plt.close()

print("System architecture diagram saved as meelo_system_architecture.png")