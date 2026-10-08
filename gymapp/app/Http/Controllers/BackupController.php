<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Carbon\Carbon;

class BackupController extends Controller
{
    private string $disk = 'local';
    private string $dir  = 'backups';

    public function index()
    {
        $files = collect(Storage::disk($this->disk)->files($this->dir))
            ->map(function ($path) {
                $name = basename($path);
                return [
                    'name' => $name,
                    'path' => $path,
                    'size' => $this->formatBytes(Storage::disk($this->disk)->size($path)),
                    'date' => Carbon::createFromTimestamp(Storage::disk($this->disk)->lastModified($path))
                                    ->format('Y-m-d H:i'),
                ];
            })
            ->sortByDesc('date')
            ->values();

        return view('backups.index', compact('files'));
    }

    public function store()
    {
        $tables = DB::select('SHOW TABLES');
        $dbName = config('database.connections.' . config('database.default') . '.database');
        $key    = 'Tables_in_' . $dbName;

        $sql = "-- Gym System Backup\n-- Date: " . Carbon::now()->toDateTimeString() . "\n\n";
        $sql .= "SET FOREIGN_KEY_CHECKS=0;\n\n";

        foreach ($tables as $table) {
            $tableName = $table->$key;

            // Drop & recreate
            $create = DB::select("SHOW CREATE TABLE `$tableName`")[0];
            $sql .= "DROP TABLE IF EXISTS `$tableName`;\n";
            $sql .= $create->{'Create Table'} . ";\n\n";

            // Data
            $rows = DB::table($tableName)->get();
            foreach ($rows as $row) {
                $values = collect((array)$row)->map(fn($v) =>
                    is_null($v) ? 'NULL' : "'" . addslashes($v) . "'"
                )->implode(', ');
                $sql .= "INSERT INTO `$tableName` VALUES ($values);\n";
            }
            $sql .= "\n";
        }

        $sql .= "SET FOREIGN_KEY_CHECKS=1;\n";

        $filename = 'backup_' . Carbon::now()->format('Y_m_d_His') . '.sql';
        Storage::disk($this->disk)->put($this->dir . '/' . $filename, $sql);

        return redirect()->route('backups.index')
                         ->with('success', __('messages.backup_created'));
    }

    public function download(string $filename)
    {
        $path = $this->dir . '/' . basename($filename);

        if (!Storage::disk($this->disk)->exists($path)) {
            abort(404);
        }

        return Storage::disk($this->disk)->download($path);
    }

    public function destroy(string $filename)
    {
        $path = $this->dir . '/' . basename($filename);

        if (Storage::disk($this->disk)->exists($path)) {
            Storage::disk($this->disk)->delete($path);
        }

        return redirect()->route('backups.index')
                         ->with('success', __('messages.backup_deleted'));
    }

    private function formatBytes(int $bytes): string
    {
        if ($bytes >= 1048576) return round($bytes / 1048576, 2) . ' MB';
        if ($bytes >= 1024)    return round($bytes / 1024, 2) . ' KB';
        return $bytes . ' B';
    }
}
